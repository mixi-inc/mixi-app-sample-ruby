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
  MIIDNzCCAh+gAwIBAgIJANH20l9V3QyGMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKDAhtaXhpIEluYzEQMA4GA1UEAwwHbWl4aS5qcDAeFw0x
  MzExMDcwODQwMzhaFw0yMzExMDUwODQwMzhaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKDAhtaXhpIEluYzEQMA4GA1UEAwwHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBAMjrvmoMZdlxPbW86JO1VbIguv8ddAQV/+ZtjmanLXU6
  QjbGz/0wAONo19R/z4oqccNI1USmGBocuNtzFaIbsXVohaJpJm6cJMQ6dYqJbWZD
  C0m8Va+8fx3xjFs/MckvymPbNCSxsycSkiwBNLM0atNiBnRRr5rLHwOlXDarOkaL
  sAYPA/EctZq4Mg380dFpDC1mqzjQvXRQ9Z9z/MD75b06EwYY4L/Yb+F92S5BhagM
  pSxfIJF7VTmA9de2PE67fhoQOXGg48fS2XE2uKDMuE1U/rQIYzAw3twFJNXiCZ3j
  F3uo8pjAy1kWY4uh9KwQ2zXEXSYjJOVDu2eX7Q+ZJDsCAwEAAaNQME4wHQYDVR0O
  BBYEFCJwA3yljcHQ917eLcEh1kIzGIE1MB8GA1UdIwQYMBaAFCJwA3yljcHQ917e
  LcEh1kIzGIE1MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAMSUBJc8
  LGLuRvhpqBfUcuHuQzzMM4Xw9x2pEcBAocu6wijvYZt1ATI6zzxC6213BT63ei4W
  UzXPYUjC70BGqQu4lhFKRECl48BLJzELayS6Lh+teYmSIdXc3DNsK9L/T19deeC5
  iHjkD76z6YPjsPpLyo3TkCi2Ebz+oNkCXQYCZsI0QToTuMuYyL+bsDyFmWTRlvx2
  KGZe3pdbMLZW4QSHoN6h0rSpgYKi6vdKbPzLcFEko1oYUwFCHDENvqVfZdMEuauA
  W58UChLDu+5bVdldYrmXkZ+u/PiSCsIVKvfCZ+JlgJR4wX+4YgICl5FbRhD/qg2l
  S791sxe9mHZeByk=
  -----END CERTIFICATE-----
  EOS

  # Touch用 OAuth Signatureの検証用公開鍵
  # http://developer.mixi.co.jp/appli/ns/touch/oauth_signature/
  TO_PUBLIC_KEY =<<-EOS.gsub(/^\s*/, "")
  -----BEGIN CERTIFICATE-----
  MIIDNzCCAh+gAwIBAgIJALrJUUWw3R2sMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKDAhtaXhpIEluYzEQMA4GA1UEAwwHbWl4aS5qcDAeFw0x
  MzExMDcwODQxMzFaFw0yMzExMDUwODQxMzFaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKDAhtaXhpIEluYzEQMA4GA1UEAwwHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBANhRS3l0OcqPbmu5GuwE4oIImw0TNJEtLnxhygWdyQ5r
  NLrMysOMHBXBW8UMvxVmh8yhUomFfTwGS6Got7aDS+9P//YiAfpFteMNhQ7NuIKD
  bHlNTjOT2wThZD+GZqkFalv5+86YmVJ09sNTEKq2W6Xip1Q1R56kcfYlBQC51et/
  aiPZF/nlpESWHM0NK3U5dD8sPutXxjnPObF47lSettnaHe/7p80oASHR87o+hqhb
  hiwIucaAwE6xqvM5qUkL4tYHDNqvTBQBErrCX4lcUkxI2Jr0BKjAU4x6Z/yxJtcS
  kxeSo8GvKVgUsk8SqJ33gdDaasy2dTrTRjMh/FP0YlUCAwEAAaNQME4wHQYDVR0O
  BBYEFDis4n7zlw2UBLRRPXbcNJEGGP+PMB8GA1UdIwQYMBaAFDis4n7zlw2UBLRR
  PXbcNJEGGP+PMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAIj/UdbB
  IS2HpArm7HHITjn/r5QhFNbtJ1PXqj+scGv7zG3QrLEelQ64kWdf/Ocr4ERdOlmW
  3yeBx6DDLJ7Gad6lcRl9PEjC+Z/A7AIf13XBozJmcMn7Qp/dQrG5HuyqvJVNZxdo
  XvFQSr3v1KfYMiSdRPjS+U0hPM5wCV19i7/82KjNU9mtwtYzw2qqN76sDESr7lbI
  EVJwUq7xE3YJcT3T6YC6AgnZ1uKO/w5kaTaUDioXTHzegNVO8g9xpk37iasu401X
  wM3cfSlKNwn2YwBYW9yeHFDDmRL60V7OD03w5vgwz/4cFGMh3qDEM/sfNhiNHFAW
  MWJRjRQVTA13wmg=
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
