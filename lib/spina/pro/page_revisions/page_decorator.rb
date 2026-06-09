module Spina::Pro::PageRevisions
  module PageDecorator
    extend ActiveSupport::Concern
  
    included do      
      has_many :page_revisions, class_name: "Spina::Pro::PageRevision", dependent: :destroy
      has_many :version_history, -> { published.select("*, row_number() OVER (PARTITION BY page_id ORDER BY updated_at) as row_number") }, class_name: "Spina::Pro::PageRevision"
      has_many :drafts, -> { draft }, class_name: "Spina::Pro::PageRevision"
    end
    
    def load_revision(revision)
      Spina.locales.each do |locale|
        send("#{locale}_content=", revision.send("#{locale}_content"))
      end
      self.draft = revision.draft
    end
    
    def save_revision!(revision = nil, updated_by: nil, draft: true)
      # Don't create a new revision if nothing changed
      return if revision.nil? && !json_attributes_changed?
      revision ||= page_revisions.create
      copy_content_to_revision(revision)
      revision.update(updated_by: updated_by, draft: draft)
    end
    
    def create_draft!(updated_by: nil)
      revision = page_revisions.create
      copy_content_to_revision(revision)
      revision.update(updated_by: updated_by, draft: true)
      revision
    end
    
    def copy_content_to_revision(revision)
      Spina.locales.each do |locale|
        revision.send("#{locale}_content=", send("#{locale}_content"))
      end
    end
  
  end
end
