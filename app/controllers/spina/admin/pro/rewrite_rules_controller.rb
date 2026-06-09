module Spina::Admin
  module Pro
    class RewriteRulesController < AdminController
      before_action :set_breadcrumbs
      
      def new
        @rewrite_rule = Spina::RewriteRule.new(old_path: params[:old_path])
      end
      
      def create
        @rewrite_rule = Spina::RewriteRule.new(rewrite_rule_params)
        if @rewrite_rule.save
          redirect_to spina.admin_pro_rewrite_rules_path
        else
          render turbo_stream: turbo_stream.update(view_context.dom_id(@rewrite_rule, :form), partial: "form")
        end
      end
  
      def index
        @rewrite_rules = Spina::RewriteRule.where(created_manually: true).page(params[:page]).per(50)
        scope_search(params[:search])
      end
      
      def destroy
        @rewrite_rule = Spina::RewriteRule.find(params[:id])
        @rewrite_rule.destroy
        render turbo_stream: turbo_stream.remove(@rewrite_rule)
      end
      
      def auto_generated
        @rewrite_rules = Spina::RewriteRule.where(created_manually: false).page(params[:page]).per(50)
        scope_search(params[:search])
        render :index
      end
      
      private
      
        def scope_search(search)
          return if search.blank?
          @rewrite_rules = @rewrite_rules.where("old_path LIKE :search OR new_path LIKE :search", search: "%#{search}%")
        end
      
        def set_breadcrumbs
          add_breadcrumb t('spina.pro.rewrite_rules.title')
        end
        
        def rewrite_rule_params
          params.require(:rewrite_rule).permit(:old_path, :new_path).merge(created_manually: true)
        end
      
    end
  end
end
