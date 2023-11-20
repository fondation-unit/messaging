namespace :messaging do
  desc "Precompile assets for Messagin"
  task :precompile_assets do
    if Rails.env.production?
      system("RAILS_ENV=production bundle exec rails app:assets:precompile")
    else
      system("bundle exec rails app:assets:precompile")
    end
  end
end
