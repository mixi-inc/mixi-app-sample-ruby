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
# = app/models/graph_api/client/persistence.rb - Persistence API用クラス
#

require 'json'

require_relative 'base'

module GraphApi
  module Client

    #
    #
    # = Description
    # Persistence APIを叩くためのクラス
    #
    # = USAGE
    # #ユーザのTokenを渡して初期化する
    # token = GraphApi::Client::Token.create("etgea4323dd")
    # token.get!("agfeaefgrbvgarhraegf45tqgravdfagqatwrb5b42")
    # persistance = GraphApi::Client::Persistence.new(token)
    #
    # #自分のUser Dataを取得する
    # user_data = persistance.get_my_user_data
    #
    # #ユーザーデータを登録する
    # response = persistance.get_friends_user_data({hoge: "fuga"})
    class Persistence < GraphApi::Client::Base

      ENDPOINT_PREFIX = '/2/apps/appdata'

      # 自分のuser dataを取得する
      # ---
      # *Returns*:: JSONレスポンス: Hash
      def get_my_user_data(params={})
        options ={params: {}, headers: {}, body: ''}
        options[:params].merge!(params)
        get(self.endpoint_myself(ENDPOINT_PREFIX), options)
      end

      # 友人のuser dataを取得する
      # ---
      # *Returns*:: JSONレスポンス: Hash
      def get_friends_user_data(params={})
        options ={params: {}, headers: {}, body: ''}
        options[:params].merge!(params)
        get(self.endpoint_myself(ENDPOINT_PREFIX), options)
      end

      # user dataを登録する
      # ---
      # *Returns*:: JSONレスポンス: Hash
      def register_user_data(req_body_hash)
	params = {}
        header = {'Content-Type' => 'application/json'}
	body = JSON(req_body_hash)
        options = {params: params, headers: header, body: body}
        post(self.endpoint_myself(ENDPOINT_PREFIX), options)
      end

      # user dataを削除する
      # ---
      # *Arguments*
      # keys: Array
      # *Returns*:: JSONレスポンス: Hash
      def delete_user_data(keys=[])
        options ={params: {fields: keys.join(',') }, headers: {}, body: ''}
        options[:params].merge!(params)
        delete(self.endpoint_myself(ENDPOINT_PREFIX), params)
      end

    end #Persistent
  end #Client
end #GraphApiClient
