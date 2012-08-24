# Copyright (c) 2012, mixi, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#  * Neither the name of the mixi, Inc. nor the names of its contributors may
#    be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# = app/controller/api_catalog_controller.rb - アプリのコントローラクラス
#

#
#
# = Description
# アプリケーションの画面遷移、モデルからのレスポンスを返すためのクラス
class ApiCatalogController < ApplicationController

  # PC用 OAuth Signatureの検証用公開鍵
  # http://developer.mixi.co.jp/appli/ns/pc/oauth_signature/
  PC_PUBLIC_KEY =<<-EOS.gsub(/^\s*/, "")
  -----BEGIN CERTIFICATE-----
  MIIDfDCCAmSgAwIBAgIJAI2n8UOEH7KvMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDAeFw0x
  MjAxMjAwMzI4MDVaFw0xNDAxMTkwMzI4MDVaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBAMZLyyXIS+3ReOuBrh5Vztt0aJwDPSgKw/Pi29B/3ODQ
  3oN+tOYGVGIN1l+V40h3QmII94OpnjoB6CbnoVdE+WIDkPx6MMzPfiWF8pbbkBad
  7WBe0T51l+EOFvRlZ0ZfHmldHGZl7GkDmXLu6jk4vcQyHFB/VS5hWpqDNw4i9vSO
  7mHspbS2cudoagJvxqwoT+ciqy1S+Nuk2Eqll7C7wL+mnTrjtC25y4zYKfWS6MpM
  rt3UlDuK75+dtknYKTNtLMVsshi/A4KMHQip0V6N4EKG+zIRExFoyPvHjTpQjJNk
  q7JF7sshPV9MIPYRwy9WJt88P80aznFR6kgp63/C0r0CAwEAAaOBlDCBkTAdBgNV
  HQ4EFgQUoiRidW+vFnj49TfzYLSKsDqI5QMwYgYDVR0jBFswWYAUoiRidW+vFnj4
  9TfzYLSKsDqI5QOhNqQ0MDIxCzAJBgNVBAYTAkpQMREwDwYDVQQKEwhtaXhpIElu
  YzEQMA4GA1UEAxMHbWl4aS5qcIIJAI2n8UOEH7KvMAwGA1UdEwQFMAMBAf8wDQYJ
  KoZIhvcNAQEFBQADggEBAJRIEbo8i44KWms5Svj0NmvweumgMbANC1k5Yf93w6wk
  Zbw+fJM+uxcxu6Z+k631+AGlahqxM/y4wXfsKfykwW6L3k4BWy/4w4owdj+5VOC7
  32G8BkhdVEP3u5cq+ySp0K1EU2AaQ6lgqaQ4T1cHZjhBrBSGiUYbwKqboqbrz7ne
  lvycCgLbvSCa4tewEkRIwhWbc+t9FNoJTdkJIN2mdqqq5yxQMIRyKM1025fEwhw8
  pX6fDv4N+LlyA2qbk+YovEQGll0fkqughEHw+K5FSdQjJ/GFnuRslOi/qCvVBc3F
  VPdLqcLz5IY3iYNonlca4VQzKp3TUjSluZIXvx7Hnhc=
  -----END CERTIFICATE-----
  EOS

  # Touch用 OAuth Signatureの検証用公開鍵
  # http://developer.mixi.co.jp/appli/ns/pc/oauth_signature/
  TO_PUBLIC_KEY =<<-EOS.gsub(/^\s*/, "")
  -----BEGIN CERTIFICATE-----
  MIIDfDCCAmSgAwIBAgIJAPCOKGmS80liMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDAeFw0x
  MjAzMDYwNTUyNDNaFw0xNDAzMDYwNTUyNDNaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBAKRlzE+PM5zdIGF4Qzg6mRlXEz0zh+sKjIIQsKk5WMZR
  XmjQDSVhiQupzrbd3YQbntwQTZNOsTIjH32O4i0+2zf81r7AClh3fWIAY9RDXajn
  Mdk4QamkdFnqEgW29cb9GMVUSmMNcCL92mPgCApmg1GPob8hqNnKe4PN3paQu49k
  Nagrc5jZDrwXcGgWPiA2CdWMwptXtggnVQR9thchTJ14s8pwRCcxLLWcFONwoGOl
  vXKcg82E8JhpGcaJ8BHS3sWWONDDtnkdIr0vVgh9Rzgw50M/GhJBQaDk17lyHbBe
  TFnCtc9Eq76QZXRx8Z1uH2HtuhHmZVA7+JR9YDKZwkkCAwEAAaOBlDCBkTAdBgNV
  HQ4EFgQUM4Jg7VVSwoN/ioj866p2j2pvq1gwYgYDVR0jBFswWYAUM4Jg7VVSwoN/
  ioj866p2j2pvq1ihNqQ0MDIxCzAJBgNVBAYTAkpQMREwDwYDVQQKEwhtaXhpIElu
  YzEQMA4GA1UEAxMHbWl4aS5qcIIJAPCOKGmS80liMAwGA1UdEwQFMAMBAf8wDQYJ
  KoZIhvcNAQEFBQADggEBAGPOXB/JDjWtuOBz4RUWlBUw60OCfsUThaE0+fYy8FV0
  MVlItYb0Nw0qU70Hfmg3VUfrcMSBfqj8vhbrQGq1VT7GAIDyly5jp4j5upA+Qeon
  5SuHTBGg837KbLCVG3UHgB40s+TphTmI74W9tzCjEseAztwx1B+TzUCIzAbWnMmk
  0favUduE0AjAEIm8bjC7M59n+dUjq5n9IEDZkXsBxIdxn2E1Gd8aTVnmpoNQUJlL
  JWW16dbxFhPE7UBBvnKAThDjdI0NFgR/DkUcfyi9E2s6MKvbrR/TSJXzci6qSiWg
  yMWRfuiI8ovJcqvfeUqxlKlzXeMA5Mx9tx+k6Qw2ZeQ=
  -----END CERTIFICATE-----
  EOS

  CONSUMER_KEY     = ENV['MIXI_CONSUMER_KEY']
  CONSUMER_SECRET  = ENV['MIXI_CONSUMER_SECRET']
  APP_URL          = ENV['MIXI_APP_URL']
  RUN_APP_URL      = ENV['MIXI_RUN_APP_URL']
  REDIRECT_URL     = "#{APP_URL}callback"
  RELAY_URL        = "#{APP_URL}mixi.html"

  # 認証後のリダイレクト先
  def callback
    if params[:error] == 'access_denied'
      render status: 403 and return
    end

    state = JSON.parse(params[:state])
    
    token = GraphApi::Client::Token.create
    token.oauth.set!(CONSUMER_KEY, CONSUMER_SECRET, REDIRECT_URL)
    token.get!(params[:code])
    render status: 500 and return if token.nil?
    people = GraphApi::Client::People.new(token)
    user_id = people.my_user_id
    render status: 500 and return if user_id.nil?
    token.user_id = user_id
    token.save!

    session = create_session_by_uid(state['session_id'], user_id)
    redirect_to main_path(device: state['device'], session_id: session.session_id)
  end

  # タイトル画面を表示
  def index
    start_page_url = URI.parse(request.url)
    verify_oauth_signature(start_page_url) do
      @sid = ActiveRecord::SessionStore.new('').generate_sid
      vid  =  params[:opensocial_viewer_id]
      if vid
        session = find_session_by_uid(vid) || create_session_by_uid(@sid, vid)
        @sid = session.session_id
        @viewer_id = session.data
      end
      @scope        = %w(mixi_apps2 r_profile).join(' ')
      @device       = params[:device]
      @consumer_key = CONSUMER_KEY
      @relay_url    = RELAY_URL
    end
  end

  # メイン表示
  def main
    @consumer_key = CONSUMER_KEY
    @app_url      = APP_URL
    @run_app_url  = RUN_APP_URL
    @relay_url    = RELAY_URL
    @device       = params[:device]
    @session_id   = params[:session_id]
  end

  # 友人一覧をjsonで返す
  def friends_lookup_table
    response = request_api_by_token(request.headers['X-SESSION-ID']) do |token|
                 people = GraphApi::Client::People.new(token)
                 people.lookup_my_friends({params: {count: 10}})
               end
    render json: response
  end

  # ユーザーデータ登録のレスポンスをjsonで返す
  def post_user_data
    response = request_api_by_token(request.headers['X-SESSION-ID']) do |token|
                 persistence = GraphApi::Client::Persistence.new(token)
                 persistence.register_user_data(
                             {params["key"] => params["value"]})
               end
    render json: response
  end

  # ユーザーデータをjsonで返す
  def get_my_user_data
    response = request_api_by_token(request.headers['X-SESSION-ID']) do |token|
                 persistence = GraphApi::Client::Persistence.new(token)
                 persistence.get_my_user_data
               end
    render json: response
  end

  private

  # 起動時に与えられるOAuth Signatureを検証する。
  # ブロックを与えて検証成功時に実行する。
  # ---
  # *Arguments*
  #  start_page_url: String
  #  &block: Proc
  #
  def verify_oauth_signature(start_page_url, &block)
    #OAuth::Signatureでbase_stringを作成するために必要な、url query stringの構築
    params.delete('action')
    params.delete('controller')

    #deviceの判定と認証用鍵の切り替え
    public_key = ""
    case params['device']
    when 'PC'
      public_key = PC_PUBLIC_KEY
    when 'TO'
      public_key = TO_PUBLIC_KEY
    else
      render status: 500 and return
    end

    query_string = params.map{|k, v| "#{k}=#{v.gsub(/\r\n/, "").gsub('+', '%2B')}"}.join("&")

    #postされたsignatureをpublic keyで復号化し、OAuth::Signature内で構築されたbase_stringと比較
    post = Net::HTTP::Post.new("#{start_page_url.path}?#{query_string}")
    consumer = OAuth::Consumer.new('', OpenSSL::X509::Certificate.new(public_key))
    signature = OAuth::Signature.build(post, {uri: start_page_url.to_s, consumer: consumer})

    if signature.verify
      block.call
    else
     render status: 500 and return
    end
  end

  # session_idからuser_idを取得する
  # ---
  # *Arguments*
  #  session_id: String
  #
  # *Return*: session data(String)
  def find_data_by_session_id(sid)
    ActiveRecord::SessionStore::Session.find_by_session_id(sid).data
  end

  # session_idからuser_idを取得する
  # ---
  # *Arguments*
  #  sid: String
  #  uid: String
  #
  # *Return*: session (ActiveRecord::SessionStore::Session)
  def create_session_by_uid(sid, uid)
    session = ActiveRecord::SessionStore::Session.new({ 
                  session_id: sid,
                  data:       uid})
    session.save!
    session
  end

  # user_idからsessionを取得する
  # ---
  # *Arguments*
  #  uid: String
  #
  # *Return*: session (ActiveRecord::SessionStore::Session)
  def find_session_by_uid(uid)
    ActiveRecord::SessionStore::Session.find_by_data(
      ActiveRecord::SessionStore::Session.marshal(uid))
  end

  # session idからtokenを取得／APIでエラーが発生した時の処理を受け持つ
  # ---
  # *Arguments*
  #  session_id: String
  #  &block:     Proc
  # *Return*: response (Hash)
  def request_api_by_token(session_id, &block)
    user_id = find_data_by_session_id(session_id)
    token = GraphApi::Client::Token.find_by_user_id(user_id)
    render status: 500 and return if token.nil?
    token.oauth.set!(CONSUMER_KEY, CONSUMER_SECRET, REDIRECT_URL)

    block.call token
  end
end
