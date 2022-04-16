class ApplicationController < ActionController::Base
    def website
        render template: 'layouts/website'
    end

    def admin
        render template: 'layouts/admin'
    end
end
