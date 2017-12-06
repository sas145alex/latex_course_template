class BooksController < ApplicationController
  skip_before_action :check_app_auth, only: [:show, :index]
  skip_before_filter :require_login, :only => [:show, :index]
  before_action -> {check_permissions('admin', 'operator')},
    except: [:show, :index]
  ...
end
