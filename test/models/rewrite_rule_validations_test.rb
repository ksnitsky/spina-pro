require "test_helper"

class RewriteRuleValidationsTest < ActiveSupport::TestCase
  test "accepts absolute paths and http(s) URLs" do
    ["/kontakt", "/", "https://example.com/page", "http://example.com"].each do |new_path|
      assert Spina::RewriteRule.new(old_path: "/old", new_path:).valid?, "#{new_path.inspect} should be valid"
    end
  end

  test "rejects path-relative and protocol-relative targets" do
    ["kontakt", "@evil.com", "//evil.com", "javascript:alert(1)"].each do |new_path|
      rule = Spina::RewriteRule.new(old_path: "/old", new_path:)

      assert_not rule.valid?, "#{new_path.inspect} should be invalid"
      assert_includes rule.errors.details[:new_path], { error: :invalid, value: new_path }
    end
  end

  test "requires new_path, with a single error when blank" do
    rule = Spina::RewriteRule.new(old_path: "/old", new_path: "")

    assert_not rule.valid?
    assert_equal [{ error: :blank }], rule.errors.details[:new_path]
  end

  test "auto-generated rules from a changed page path still save" do
    # Spina::Page#rewrite_rule does exactly this when a page's materialized_path changes.
    assert Spina::RewriteRule.where(old_path: "/old-page").first_or_create.update(new_path: "/new-page")
    assert_equal "/new-page", Spina::RewriteRule.find_by!(old_path: "/old-page").new_path
  end
end
