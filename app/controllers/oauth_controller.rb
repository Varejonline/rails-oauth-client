class OauthController < ApplicationController
  
  APP_ID = "COLOQUE_SEU_APP_ID"
  APP_SECRET = "COLOQUE_SEU_APP_SECRET"
  VPSA_AUTHORIZATION_URL = "https://www.vpsa.com.br/apps/oauth/authorization"
  VPSA_TOKEN_URL = "https://www.vpsa.com.br/apps/oauth/token"
  
  def authorization
    oauth_params = {
      :response_type => :code,
      :app_id => APP_ID,
      :redirect_uri => oauth_callback_url
    }
    redirect_to VPSA_AUTHORIZATION_URL + "?" + oauth_params.to_query
  end
  
  def callback
    options = {
      :body => {
        :grant_type => :authorization_code, 
        :app_id => APP_ID, 
        :app_secret => APP_SECRET,
        :redirect_uri => oauth_callback_url,
        :code => params[:code]
      }.to_json,
      :headers => { 'Content-Type' => 'application/json' }
    }
    @parsed_response = HTTParty.post(VPSA_TOKEN_URL, options).parsed_response
    session['access_token'] = @parsed_response['access_token']
  end
  
end