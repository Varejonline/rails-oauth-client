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
    response = HTTParty.post(VPSA_TOKEN_URL, options)
    
    parse_response(response.parsed_response) if response.success?
       
    render "home/index"
  end
  
  def logout
    session[:usuario] = nil
    render "home/index"
  end

  private 
  
  def parse_response parsed_response
    session[:usuario] = {
      :access_token => parsed_response['access_token'],
      :expires_in => parsed_response['expires_in'],
      :refresh_token => parsed_response['refresh_token'],
      :id_terceiro => parsed_response['id_terceiro'],
      :nome_terceiro => parsed_response['nome_terceiro'],
      :cnpj_empresa => parsed_response['cnpj_empresa']
    }
  end
  
end