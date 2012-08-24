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
# = app/models/graph_api/client/people.rb - People API用クラス
#

require_relative 'base'

module GraphApi
  module Client

    #
    #
    # = Description
    # People APIを叩くためのクラス
    #
    # = USAGE
    # #ユーザのTokenを渡して初期化する
    # token = GraphApi::Client::Token.create_by_user_id([USER_ID])
    # token.get!([AUTHORIZATION_CODE])
    # people = GraphApi::Client::People.new(token)
    #
    # #友人一覧を取得する
    # friends = people.lookup_friends
    #
    # #自分のプロフィールを取得する
    # my_profile = people.get_my_profile
    class People < GraphApi::Client::Base

      ENDPOINT_PREFIX = '/2/people'

      # 友人一覧を取得する
      # ---
      # *Returns*:: JSONレスポンス: Hash
      def lookup_friends(user_id='@me', group_id='@friends', args={})
        endpoint = "#{ENDPOINT_PREFIX}/#{user_id}/#{group_id}"
        args ||= {}
        get(endpoint, args)
      end

      def lookup_my_friends(args={})
        lookup_friends('@me', '@friends', args)
      end

      # 自分のプロフィールを取得する
      # ---
      # *Returns*:: JSONレスポンス: Hash
      def get_my_profile
        get(endpoint_myself(ENDPOINT_PREFIX))
      end

      # ユーザーIDを取得する
      # ---
      # *Returns*:: ユーザID: String
      def my_user_id
        my_profile = self.get_my_profile
	my_profile['entry']['id']
      end

    end #People
  end #Client
end #GraphApi
