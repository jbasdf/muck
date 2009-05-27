class AddLanguages < ActiveRecord::Migration
  def self.up
    execute "INSERT INTO languages (code, name) VALUES ('en', 'English')"
    execute "INSERT INTO languages (code, name) VALUES ('ru', 'Русский язык')"
    execute "INSERT INTO languages (code, name) VALUES ('nl', 'Nederlands')"
    execute "INSERT INTO languages (code, name) VALUES ('ja', '日本語')"
    execute "INSERT INTO languages (code, name) VALUES ('zh', '中文')"
    execute "INSERT INTO languages (code, name) VALUES ('fr', 'Français')"
    execute "INSERT INTO languages (code, name) VALUES ('de', 'Deutsch')"
    execute "INSERT INTO languages (code, name) VALUES ('es', 'Español')"
  end

  def self.down
    execute "DELETE FROM languages WHERE code IN ('en','ru','nl','ja','zh','fr','de','es')"
  end
end
