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
# = app/models/graph_api/client/oauth.rb - Token取得用シングルトンクラス
#

require 'net/https'
require 'uri'
require 'json'
require 'singleton'

module GraphApi
  module Client

    HOST = 'secure.mixi-platform.com' 
    PATH = '/2/token'
    #
    #
    # = Description
    # HTTPでアクセストークを取得するためのクラスメソッドをまとめたクラス
    #
    # = USAGE
    #
    # #GraphApi::Client::OAuthのインスタンスを作成して、必要な値をセットする
    # oauth = GraphApi::Client::OAuth.instance
    # oatuh.set!( 'a_consumer_key', 'a_consumer_secret', 'a_redirect_uri')
    #
    # #Authorizaiton Codeを使って新規にTokenを取得
    # token = oauth.create_token('xxxxxxxxxxxxxxxxxxxxxxxxx')
    #
    # #Refresh Tokenを使ってAccess Tokenのリフレッシュ
    # token = oauth.refresh_token('xxxxxxxxxxxxxxxxxxxxxxxxx')
    class OAuth
      include Singleton

      # Token取得に必要な値をセットする
      # ---
      # *Arguments*
      # (required) consumer_key: String
      # (required) consumer_secret: String
      # (required) redirect_uri: String
      def set!(consumer_key, consumer_secret, redirect_uri)
        @consumer_key = consumer_key
        @consumer_secret = consumer_secret
        @redirect_uri = redirect_uri
        self
      end

      # Authorization Codeからアクセストークンを取得する
      # ---
      # *Arguments*
      # (required) authorzaition_code: String 
      # *Returns*:: JSONレスポンス: Hash
      def create_token(authorization_code, params={})
        query_params = {grant_type: 'authorization_code',
                        code:       authorization_code}.merge(params)
        get_token(query_params)
      end

      # Refresh Tokenからアクセストークンを取得する
      # ---
      # *Arguments*
      # (required) refresh_toekn: String 
      # *Returns*:: JSONレスポンス: Hash
      def refresh_token(refresh_token, params={})
        query_params = {grant_type:    'refresh_token',
                        refresh_token: refresh_token}.merge(params)
        get_token(query_params)
      end

      private
      # token取得のためのHTTPリクエストを叩く
      # ---
      # *Arguments*
      # (required) refresh_toekn: String 
      # *Returns*:: JSONレスポンス: Hash
      def get_token(params={})
        query_params = {client_id:     @consumer_key,
                        client_secret: @consumer_secret,
                        redirect_uri:  @redirect_uri}.merge(params)
        endpoint = URI::HTTP.build({host: HOST, path: PATH})
 
        req = Net::HTTP::Post.new(endpoint.request_uri)
        req.set_form_data(query_params)
        https = Net::HTTP.new(endpoint.host, 443)
        https.use_ssl = true
          res = https.request(req)
          res_body = JSON.parse(res.body)
      end

    end #OAuth
  end #Client
end #GraphApi
