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
# = app/models/graph_api/client/base.rb - API通信の共通クラス
#

require 'net/https'
require 'uri'
require 'json'

module GraphApi
  module Client

    #
    #
    # = Description
    # HTTPでGraph APIために必要なメソッドを切り出したモジュール
    #
    # = USAGE
    #  # APIを利用するクラスにmix-in
    #  require_relative 'base'
    #
    #  module GraphApi
    #    module Client
    #      class People
    #
    #      include GraphApi::Client::Base
    #
    #  # mix-inされたクラスでは、GraphApi::Client::Token
    #  # のオブジェクトを渡して初期化する
    #  GraphApi::Client::People.new(token)
    #
    #  #Graph APIの指定のエンドポイントに対しGETをする
    #  ENDPOINT_PREFIX = '/2/people'
    #  def get_my_profile
    #    self.get(endpoint_myself(ENDPOINT_PREFIX), [])
    #  end
    class Base

      HOST    = 'api.mixi-platform.com'

      ME      = '@me'
      SELF    = '@self'
      FRIENDS = '@friends'

      # Graph APIを叩くことでデータをやりとりするクラスの初期化メソッド
      # ---
      # *Arguments*
      # (required) token: GraphApi::Client::Token
      def initialize(token)
        @token = token
      end

      # エンドポイントに/@me/@selfを指定。
      # ---
      # *Arguments*
      # (required) endpoint_prefix: String 
      # *Returns*:: [endpoint_myself]/@me/@self: String
      def endpoint_myself(endpoint_prefix)
        "#{endpoint_prefix}/#{ME}/#{SELF}"
      end

      # エンドポイントに/@me/@friendsを指定。
      # ---
      # *Arguments*
      # (required) endpoint_prefix: String 
      # *Returns*:: [endpoint_myself]/@me/@friends: String
      def endpoint_friends(endpoint_prefix)
        "#{endpoint_prefix}/#{ME}/#{FRIENDS}"
      end

      # mixi platformのエンドポイントに対してGETを行う。
      # ---
      # *Arguments*
      # (required) path: String
      # (optional) options: Hash { params: Hash, header: Hash, body: String }
      # *Returns*:: JSONレスポンス: Hash
      def get(path, options={})
        call_api(:get, path, options)
      end

      # mixi platformのエンドポイントに対してPOSTを行う。
      # ---
      # *Arguments*
      # (required) path: String
      # (optional) options: Hash { params: Hash, header: Hash, body: String }
      # *Returns*:: JSONレスポンス: Hash
      def post(path, options={})
        call_api(:post, path, options)
      end

      # mixi platformのエンドポイントに対してPUTを行う。
      # ---
      # *Arguments*
      # (required) path: String
      # (optional) options: Hash { params: Hash, header: Hash, body: String }
      # *Returns*:: JSONレスポンス: Hash 
      def put(path, options={})
        call_api(:put, path, options)
      end

      # mixi platformのエンドポイントに対してGETを行う。
      # ---
      # *Arguments*
      # (required) path: String
      # (optional) options: Hash { params: Hash, header: Hash, body: String }
      # *Returns*:: JSONレスポンス: Hash 
      def delete(path, options={})
        call_api(:delete, path, options)
      end


      private
      # 指定されたHTTPメソッドでmixi platformのエンドポイントを叩く。
      # ---
      # *Arguments*
      # (required) method: String
      # (required) path: String
      # (optional) options: Hash { params: Hash, header: Hash, body: String }
      # *Returns*:: JSONレスポンス: Hash  
      def call_api(method, path, options={})
        options = {params: {}, headers: {}, body: ""}.merge!(options)
        query_string = options[:params].map{|key, value| URI.encode("#{key}=#{value}") }.join('&') if !options[:params].empty?
        uri_elems = {host: HOST, path: path}
        uri_elems.merge!({query: query_string}) if query_string
        endpoint = URI::HTTP.build(uri_elems);
  
        req = Net::HTTP.const_get(method.to_s.capitalize).new(endpoint.request_uri)
        @token.refresh! if @token.expired?
        req.add_field 'Authorization', "OAuth #{@token.access_token}"
        req.content_type = options[:headers]['Content-Type'] if options[:headers].has_key? 'Content-Type'
	req.body = options[:body]

        https = Net::HTTP.new(endpoint.host, 443)
        https.use_ssl = true
	begin
	  res = https.request(req)
        rescue Exception
          return {exception: $!}
        end
        res.body.empty? ? {} : JSON.parse(res.body);
      end 

    end #Base
  end #Client
end #GraphApi
