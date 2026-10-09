require "test_helper"

class RewriteRuleValidationsTest < ActiveSupport::TestCase
  test "accepts absolute paths and http(s) URLs" do
    ["/kontakt", "/", "/über-uns", "/a?b=1#x", "https://example.com/page", "http://example.com", "HTTPS://example.com"].each do |new_path|
      assert Spina::RewriteRule.new(old_path: "/old", new_path:).valid?, "#{new_path.inspect} should be valid"
    end
  end

  test "rejects path-relative and protocol-relative targets" do
    ["kontakt", "@evil.com", "//evil.com", "/\\evil.com", "javascript:alert(1)", "https://", "https:///evil.com"].each do |new_path|
      rule = Spina::RewriteRule.new(old_path: "/old", new_path:)

      assert_not rule.valid?, "#{new_path.inspect} should be invalid"
      assert_includes rule.errors.details[:new_path], { error: :invalid, value: new_path }
    end
  end

  test "rejects whitespace and control characters" do
    ["/kontakt\n", "/kontakt\n//evil.com", "/\t/evil.com", "/kon takt", "https://example.com/ page", "/a\x00b", "/a\x01b", "/a\x7f", "/kon\u00A0takt", "/a\u200Bb", "https://\u00A0evil.com"].each do |new_path|
      assert_not Spina::RewriteRule.new(old_path: "/old", new_path:).valid?, "#{new_path.inspect} should be invalid"
    end
  end

  test "explains what an invalid new_path must look like" do
    rule = Spina::RewriteRule.new(old_path: "/old", new_path: "kontakt")
    rule.validate

    assert_equal [I18n.t("activerecord.errors.models.spina/rewrite_rule.attributes.new_path.invalid", locale: :en)], rule.errors[:new_path]
    assert_equal "must start with / or http(s)://", rule.errors[:new_path].first
  end

  test "requires new_path, with a single error when blank" do
    rule = Spina::RewriteRule.new(old_path: "/old", new_path: "")

    assert_not rule.valid?
    assert_equal [{ error: :blank }], rule.errors.details[:new_path]
  end

  test "auto-generated rules from a changed page path still save" do
    page = Spina::Page.create!(title: "Old page")
    page.update!(url_title: "New page")

    assert_equal "/new-page", Spina::RewriteRule.find_by!(old_path: "/old-page").new_path
  end
end
