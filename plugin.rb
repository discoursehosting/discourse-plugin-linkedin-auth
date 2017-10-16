# name: discourse-plugin-linkedin-auth-customfields
# about: Enable Login via LinkedIn and copy some fields
# version: 0.0.3
# authors: Matthew Wilkin and DiscourseHosting.com
# url: https://github.com/discoursehosting/discourse-plugin-linkedin-auth-customfields

require 'auth/oauth2_authenticator'

gem 'omniauth-linkedin-oauth2', '0.2.5'

enabled_site_setting :linkedin_enabled

class LinkedInAuthenticator < ::Auth::OAuth2Authenticator
  PLUGIN_NAME = 'oauth-linkedin'

  def name
    'linkedin'
  end

  def after_authenticate(auth_token)
    result = super
    if result.user && result.email && (result.user.email != result.email)
      begin
        result.user.primary_email.update!(email: result.email)
      rescue
        used_by = User.find_by_email(result.email)&.username
        Rails.logger.warn("FAILED to update email for #{user.username} to #{result.email} cause it is in use by #{used_by}")
      end
    end

    result.extra_data = {
      uid: auth_token[:uid],
      provider: auth_token[:provider],
      profile: auth_token['info']['urls']['public_profile'],
      location: auth_token['info']['location']['name'],
      title: auth_token['info']['description']
    }

    add_information(result.user, result.extra_data)

    result
  end

  def add_information(user, data)
    if user
      begin
        dirty = false
        field_no = UserField.where(name: "LinkedIn Profile").pluck('id').first
        if field_no
          user.custom_fields["user_field_#{field_no}"] = data[:profile]
          dirty = true
        end
        field_no = UserField.where(name: "Location").pluck('id').first
        if field_no
          user.custom_fields["user_field_#{field_no}"] = data[:location]
          dirty = true
        end
        field_no = UserField.where(name: "Title").pluck('id').first
        if field_no
          user.custom_fields["user_field_#{field_no}"] = data[:title]
          dirty = true
        end
        user.save_custom_fields if dirty
      rescue => ex
        Rails.logger.warn("FAILED to set custom fields for #{user.username}")
      end
    end
  end

  def after_create_account(user, auth)
    result = super
    add_information(user, auth[:extra_data])
    result
  end

  def register_middleware(omniauth)
    omniauth.provider :linkedin,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:client_id] = SiteSetting.linkedin_client_id
                        strategy.options[:client_secret] = SiteSetting.linkedin_secret
                      }
  end
end

auth_provider title: 'with LinkedIn',
              enabled_setting: "linkedin_enabled",
              message: 'Log in via LinkedIn',
              frame_width: 920,
              frame_height: 800,
              authenticator: LinkedInAuthenticator.new(
                'linkedin',
                trusted: true,
                auto_create_account: true
              )

register_css <<CSS

.btn-social.linkedin {
  background: #46698f;
}

.btn-social.linkedin::before {
  content: $fa-var-linkedin;
}

CSS
