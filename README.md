# LinkedIn OAuth Login Plugin
This plugin adds support logging in via LinkedIn.

It also adds the possibility to copy the LinkedIn Profile, Location and Title to a user and show it on the profile and user card.

The development of this functionality was kindly sponsored by Foo Chek Wee of [Thrive in Asia](https://thriveinasia.com/)

Admin Settings  
![](https://raw.githubusercontent.com/discourse/discourse-plugin-linkedin-auth/master/screenshot-admin-settings.png)

Login Screen  
![](https://raw.githubusercontent.com/discourse/discourse-plugin-linkedin-auth/master/screenshot-login-screen.png)

## How to Help

- Create a PR with a new translation!
- Log Issues
- Submit PRs to help resolve issues

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using https://github.com/discourse/discourse-plugin-linkedin-auth.git as the repository URL.
2. Rebuild the app using `./launcher rebuild app`
3. Visit https://developer.linkedin.com/docs/oauth2 and follow the directions for [creating an application](https://www.linkedin.com/secure/developer?newapp=), or look up the details of your [existing application](https://www.linkedin.com/secure/developer).
4. Update the plugin settings in the Admin > Settings area.
5. Add the your website as an authorized redirect url using  
`https://example.com/auth/linkedin/callback`  
(replacing the https with http and example.com with your full qualified domain/subdomain)

6. Add the following custom fields: 
- LinkedIn Profile
- Location
- Title

7. Add a theme in order to make the Profile URL clickable and to hide these fields from the signup form, for example [this one](https://github.com/discoursehosting/discourse-linkedin-user-fields)

## Authors

Matthew Wilkin
[DiscourseHosting.com](https://www.discoursehosting.com/)

## License

GNU GPL v2
