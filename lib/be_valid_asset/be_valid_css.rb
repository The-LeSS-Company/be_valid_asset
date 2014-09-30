require 'net/http'

module BeValidAsset

  Configuration.css_validator_host = 'jigsaw.w3.org'
  Configuration.css_validator_path = '/css-validator/validator'

  class BeValidCss < BeValidBase
  
    def initialize(profile)
      @profile = profile
    end
  
    def matches?(fragment)

      if fragment.respond_to? :body
        fragment = fragment.body.to_s
      end

      # The validator return a 500 Error if it's sent empty string
      fragment = ' ' if fragment.empty?

      query_params = { :text => fragment, :profile => @profile, :vextwarning => 'true' }
      return validate(query_params)
    end
  
    def description
      "be valid css"
    end
  
    def failure_message
      " expected css to be valid, but validation produced these errors:\n#{@message}"
    end

    def failure_message_when_negated
      " expected to not be valid, but was (missing validation?)"
    end
    # continue to support Rspec < 3
    alias :negative_failure_message :failure_message_when_negated

    private

      def validator_host
        Configuration.css_validator_host
      end

      def validator_path
        Configuration.css_validator_path
      end

      def error_line_prefix
        'Invalid css'
      end

  end
  
  def be_valid_css(profile = 'css21')
    BeValidCss.new(profile)
  end

  def be_valid_css1
    be_valid_css 'css1'
  end

  def be_valid_css2
    be_valid_css 'css21'
  end

  def be_valid_css3
    be_valid_css 'css3'
  end
end