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

require 'spec_helper'

describe ApiCatalogController do

  describe 'GET callback' do
    it 'should redirect to main' do
      oauth = mock(GraphApi::Client::OAuth)
      oauth.stub!(:set!).and_return(oauth) 
      token = mock(GraphApi::Client::Token)
      token.stub!(:oauth).and_return(oauth) 
      token.stub!(:get!)
      token.stub!(:user_id=)
      token.stub!(:save!)
      GraphApi::Client::Token.stub!(:create).and_return(token)
      people = mock(GraphApi::Client::People)
      people.stub!(:my_user_id).and_return('test')
      GraphApi::Client::People.stub!(:new).and_return(people)
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:save!)
      session.stub!(:session_id).and_return('sesison_id')
      ActiveRecord::SessionStore::Session.stub!(:new).and_return(session)

      get 'callback', state: '{"user_id" : "test", "device" : "device"}', code: 'test' 
      response.code.should == '302'
      response.should redirect_to '/main?device=device&session_id=sesison_id'
    end
  end

  describe 'POST index' do
    it 'should assign correct instance variables when opensocial_viewer_id does not exist' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)
      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)
      post 'index', device: 'PC'
      
      assigns(:sid).should == 'sid'
      assigns(:scope).should == 'mixi_apps2 r_profile'
      assigns(:device).should == 'PC'
      assigns(:consumer_key).should == 'key'
      assigns(:relay_url).should == '/app/mixi.html'
    end

    it 'should assign correct instance variables when opensocial_viewer_id and a session exist' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)
      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:save!)
      session.stub!(:session_id).and_return('new_sid')
      session.stub!(:data).and_return('data')
      ActiveRecord::SessionStore::Session.stub!(:find_by_data).and_return(session)

      post 'index', device: 'PC', opensocial_viewer_id: 'viewer'      
      assigns(:sid).should == 'new_sid'
      assigns(:viewer_id).should == 'data'
      assigns(:scope).should == 'mixi_apps2 r_profile'
      assigns(:device).should == 'PC'
      assigns(:consumer_key).should == 'key'
      assigns(:relay_url).should == '/app/mixi.html'
    end

    it 'should assign correct instance variables when opensocial_viewer_id exists' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)
      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)
      ActiveRecord::SessionStore::Session.stub!(:find_by_data).and_return(nil)

      post 'index', device: 'PC', opensocial_viewer_id: 'viewer'      
      assigns(:sid).should == 'sid'
      assigns(:viewer_id).should == 'viewer'
      assigns(:scope).should == 'mixi_apps2 r_profile'
      assigns(:device).should == 'PC'
      assigns(:consumer_key).should == 'key'
      assigns(:relay_url).should == '/app/mixi.html'
    end
  end

  describe 'GET main' do
    it 'should assign correct instance variables' do
      get 'main', device: 'device', session_id: 'session_id'
      assigns(:consumer_key).should == 'key'
      assigns(:app_url).should == '/app/'
      assigns(:run_app_url).should == '/run_app/'
      assigns(:relay_url).should == '/app/mixi.html'
      assigns(:device).should == 'device'
      assigns(:session_id).should == 'session_id'
    end
  end

  describe 'GET friends_lookup_table' do
    it 'should render a json value' do
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:data).and_return('user_id')
      ActiveRecord::SessionStore::Session.stub!(:find_by_session_id).and_return(session)
      token = mock(GraphApi::Client::Token)
      token.stub!(:nil?).and_return(false)
      oauth = mock(GraphApi::Client::OAuth)
      oauth.stub!(:set!).and_return(oauth) 
      token.stub!(:oauth).and_return(oauth) 
      GraphApi::Client::Token.stub!(:find_by_user_id).and_return(token)
      response = {status: 200}
      people = mock(GraphApi::Client::People)
      people.stub!(:lookup_my_friends).with({params: {count: 10}}).and_return(response)
      GraphApi::Client::People.stub!(:new).and_return(people)

      get 'friends_lookup_table'
      response.should == response
    end
  end

  describe 'POST post_user_data' do
    it 'should render a json value' do
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:data).and_return('user_id')
      ActiveRecord::SessionStore::Session.stub!(:find_by_session_id).and_return(session)
      token = mock(GraphApi::Client::Token)
      token.stub!(:nil?).and_return(false)
      token.stub!(:expired?).and_return(false);
      token.stub!(:access_token).and_return('aaaaaa');
      oauth = mock(GraphApi::Client::OAuth)
      oauth.stub!(:set!).and_return(oauth) 
      token.stub!(:oauth).and_return(oauth) 
      GraphApi::Client::Token.stub!(:find_by_user_id).and_return(token)
      response = {'status' =>  200}
      persistence = mock(GraphApi::Client::Persistence)
      persistence.stub!(:register_user_data).and_return(response)
      GraphApi::Client::Persistence.stub!(:new).and_return(persistence)

      post 'friends_lookup_table'
      response.should == response
    end
  end

  describe 'GET get_my_user_data' do
    it 'should render a json value' do
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:data).and_return('user_id')
      ActiveRecord::SessionStore::Session.stub!(:find_by_session_id).and_return(session)
      token = mock(GraphApi::Client::Token)
      token.stub!(:nil?).and_return(false)
      token.stub!(:expired?).and_return(false);
      token.stub!(:access_token).and_return('aaaaaa');
      oauth = mock(GraphApi::Client::OAuth)
      oauth.stub!(:set!).and_return(oauth) 
      token.stub!(:oauth).and_return(oauth) 
      GraphApi::Client::Token.stub!(:find_by_user_id).and_return(token)
      response = {status: 200}
      persistence = mock(GraphApi::Client::Persistence)
      persistence.stub!(:get_my_user_data).and_return(response)
      GraphApi::Client::Persistence.stub!(:new).and_return(persistence)

      get 'get_my_user_data'
      response.should == response
    end
  end

end
