# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( login.js login.scss )
Rails.application.config.assets.precompile += %w( home.js )
Rails.application.config.assets.precompile += %w( sign_up.js )
Rails.application.config.assets.precompile += %w( client_info.js suggest_message_list.js modal.scss )
Rails.application.config.assets.precompile += %w( csv_import.js csv_import.scss )
Rails.application.config.assets.precompile += %w( csv_export.js )
