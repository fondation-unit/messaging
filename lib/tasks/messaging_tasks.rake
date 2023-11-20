namespace :messaging do
  desc "Precompile assets for Messaging"
  task :precompile_assets do
    if Rails.env.production?
      system("RAILS_ENV=production bundle exec rails assets:precompile")
    else
      system("bundle exec rails assets:precompile")
    end
  end
end
