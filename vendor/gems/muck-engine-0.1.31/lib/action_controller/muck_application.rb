module ActionController
    
  module MuckApplication
    
    module ClassMethods

    end

    module InstanceMethods
      protected

      # **********************************************
      # Locale methods
      # I18n methods from:
      # http://guides.rubyonrails.org/i18n.html
      # http://zargony.com/2009/01/09/selecting-the-locale-for-a-request
      def discover_locale
        I18n.locale = extract_locale_from_user_selection || extract_locale_from_tld || extract_locale_from_subdomain || extract_locale_from_headers || I18n.default_locale
      end
      
      def extract_locale_from_browser
        if http_lang = request.env["HTTP_ACCEPT_LANGUAGE"] and ! http_lang.blank?
          browser_locale = http_lang[/^[a-z]{2}/i].downcase + '-' + http_lang[3,2].upcase
          browser_locale.sub!(/-US/, '')
        end
        nil
      end

      def extract_locale_from_user_selection
        if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
          cookies['locale'] = { :value => params[:locale], :expires => 1.year.from_now }
          params[:locale].to_sym
        elsif cookies['locale'] && I18n.available_locales.include?(cookies['locale'].to_sym)
          cookies['locale'].to_sym
        end
      end
      
      def extract_locale_from_headers
        if http_lang = request.headers["HTTP_ACCEPT_LANGUAGE"] and ! http_lang.blank?
          preferred_locales = http_lang.split(',').map { |l| l.split(';').first }
          accepted_locales = preferred_locales.select { |l| I18n.available_locales.include?(l.to_sym) }
          accepted_locales.empty? ? nil : accepted_locales.first.to_sym
        end
      end
      
      # Get locale from top-level domain or return nil if such locale is not available 
      # You have to put something like: # 127.0.0.1 application.com 
      # 127.0.0.1 application.it # 127.0.0.1 application.pl 
      # in your /etc/hosts file to try this out locally 
      def extract_locale_from_tld 
        parsed_locale = request.host.split('.').last 
        (I18n.available_locales.include? parsed_locale) ? parsed_locale.to_sym : nil 
      end 

      # Get locale code from request subdomain (like http://it.application.local:3000) 
      # You have to put something like: 
      # 127.0.0.1 gr.application.local 
      # in your /etc/hosts file to try this out locally 
      def extract_locale_from_subdomain 
        parsed_locale = request.subdomains.first
        if !parsed_locale.blank?
          I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale.to_sym : nil 
        else
          nil
        end
      end
            
      # **********************************************
      # Paging methods
      def setup_paging
        @page = (params[:page] || 1).to_i
        @page = 1 if @page < 1
        @per_page = (params[:per_page] || (RAILS_ENV=='test' ? 1 : 40)).to_i
      end

      def set_will_paginate_string
        # Because I18n.locale are dynamically determined in ApplicationController, 
        # it should not put in config/initializers/will_paginate.rb
        WillPaginate::ViewHelpers.pagination_options[:previous_label] = t('muck.general.previous')
        WillPaginate::ViewHelpers.pagination_options[:next_label] = t('muck.general.next')
      end

      # **********************************************
      # Email methods
      
      # Use send_form_email to send the contents of any form to the support email address
      def send_form_email(params, subject)
        body = []
        params.each_pair { |k,v| body << "#{k}: #{v}"  }
        BasicMailer.deliver_mail(:subject => subject, :body => body.join("\n"))
      end
      
      
      def get_redirect_to
        if params[:redirect_to]
          redirect_to params[:redirect_to]
        else
          yield
        end
      end

      # render methods
      def render_as_html
        last_template_format = @template.template_format
        @template.template_format = :html
        result = yield
        @template.template_format = last_template_format
        result
      end
      
      # **********************************************
      # Parent methods
      
      # Attempts to create an @parent object using params
      # or the url.
      def setup_parent(*ignore)
        @parent = get_parent(ignore)
        if @parent.blank?
          render :text => t('muck.engine.missing_parent_error')
          return false
        end
      end

      # Tries to get parent using parent_type and parent_id from the url.
      # If that fails and attempt is then made using find_parent
      # parameters:
      # ignore: Names to ignore.  For example if the url is /foo/1/bar?thing_id=1
      #         you might want to ignore thing_id so pass :thing.
      def get_parent(*ignore)
        if params[:parent_type].blank? || params[:parent_id].blank?
          find_parent(ignore)
        else
          klass = params[:parent_type].to_s.constantize
          klass.find(params[:parent_id])
        end
      end

      # Searches the params to try and find an entry ending with _id
      # ie article_id, user_id, etc.  Will return the first value found.
      # parameters:
      # ignore: Names to ignore.  For example if the url is /foo/1/bar?thing_id=1
      #         you might want to ignore thing_id so pass 'thing' to be ignored.
      def find_parent(*ignore)
        ignore.flatten!
        params.each do |name, value|
          if name =~ /(.+)_id$/
            if !ignore.include?($1)
              return $1.classify.constantize.find(value)
            end
          end
        end
        nil
      end
      
    end

    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.class_eval do
        include InstanceMethods
      end
    end

  end

end