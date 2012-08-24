/*
 * Copyright (c) 2012, mixi, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  * Neither the name of the mixi, Inc. nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

if (typeof(qs) === 'undefined') {
   qs = {};
}
qs.api = {

    appUrl: '',
    runAppUrl: '',
    sid: '',

    // 招待を送る
    postInvite: function() {
        opensocial.requestShareApp("VIEWER_FRIENDS", null, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')');
                // do something...
            }
            else {
                // do something...
            }
        });
    },

    // リクエストを送る
    postRequest: function(imgPath, body) {
        var mediaItem = opensocial.newMediaItem("image/png", this.appUrl + imgPath);
        var params = {};
        params[mixi.Request.Field.IMAGE] = mediaItem;
        params[mixi.Request.Field.FILTER_TYPE] = mixi.Request.FilterType.BOTH;
        params[mixi.Request.Field.URL] = this.runAppUrl;
        params[mixi.Request.Field.BODY] = body;

        opensocial.requestShareApp("VIEWER_FRIENDS", null, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')');
                // do something...
            }
            else {
                var data = response.getData();
                var recipientIds = data["recipientIds"];
                var requestId    = data["requestId"];
                // do something...
            }
        }, params);
    },

    // アクティビティを送る
    postActivity: function(imgPath, title) {
        var mediaItem = opensocial.newMediaItem("image/png", this.appUrl + imgPath);
        var params = {};
        params[opensocial.Activity.Field.TITLE] = title;
        params[opensocial.Activity.Field.MEDIA_ITEMS] = [mediaItem];
        var activity = opensocial.newActivity(params);
        opensocial.requestCreateActivity(
            activity, opensocial.CreateActivityPriority.HIGH, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')');
                // do something...
            }
            else {
                // do something...
            }
        });
    },

    // メッセージを送る
    postMessage: function(user, title, body) {
        var params = {};
        params[opensocial.Message.Field.TITLE] = title;
        var msg = opensocial.newMessage(body, params);
        opensocial.requestSendMessage([user], msg, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')' + " ※法人アカウントはメッセージを送信できません");
                // do something...
            }
            else {
                // do something...
            }
        });
    },

    // ボイスを投稿する
    postVoice: function(status) {
        var params = {};
        params[mixi.Status.Field.URL] = this.runAppUrl;
        params[mixi.Status.Field.TOUCH_URL] = this.runAppUrl;
        mixi.requestUpdateStatus(status, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')');
                // do something...
            }
            else {
                // do something...
            }
        }, params);
    },

    // 写真を投稿する
    postPhoto: function(imgPath) {
        var mediaItem = opensocial.newMediaItem(
            opensocial.MediaItem.Type.IMAGE, this.appUrl + imgPath);
        mixi.requestUploadMediaItem(mediaItem, function(response) {
            if (response.hadError()) {
                var ecode = response.getErrorCode();
                var emsg  = response.getErrorMessage();
                qs.dialog.showMsg('失敗', emsg + '(' + ecode + ')');
                // do something...
            }
            else {
                // do something...
            }
        });
    },

    // 外部サイトに遷移する
    goOut: function(url) {
        mixi.util.requestExternalNavigateTo(url);
    },

    // 友人一覧を表示する
    showFriendsList: function() {
        this.send(
            'friends_lookup_table',
            'GET',
            {},
            function(data) {
            qs.dialog.showfriendList(data);
            }
        );
    },

    // ユーザ単位の文字列情報を登録する
    postUserData: function(key, value) {
        this.send(
            'post_user_data',
            'POST',
            {
                key: key,
                value: value
            },
            function(data) {
                qs.api.showUserData();
            }
        );
    },

    // ユーザ単位の文字列情報を表示する
    showUserData: function() {
        this.send(
            'get_my_user_data',
            'GET',
            {},
            function(data) {
                qs.dialog.showUserData(data);
            }
        );
    },

    // メッセージを送る友人一覧を表示する
    showMessageFriendsList: function() {
        this.send(
            'friends_lookup_table',
            'GET',
            {},
            function(data) {
                $.each(data.entry, function(i, item){
                    $('<li>').attr('class', 'selectFriend').attr('id', item.id).append(
                        $('<a>').attr('href', '#').append(
                            $('<img>').attr('src', item.thumbnailUrl).attr('alt', item.displayName)
                        )
                    ).appendTo($('#messageFriends'));
                });
                $('.selectFriend').click(function() {
                    qs.api.postMessage(
                        $(this).attr('id'),
                        "最近元気にしている？",
                        "チャット楽しいね！またお話しよう！"
                    );
                });
           }
        );
    },

    // ajaxでサーバと通信を行う
    send: function(url, method, data, callback) {
        $.ajax({
            url: url,
            type: method,
            headers: { 'X-SESSION-ID': this.sid },
            data: data,
            success: callback,
            error: function(xhr, textStatus, errorThrown){
                qs.dialog.showMsg('失敗', 'error: ' + errorThrown);
            }
        });
    }

};



qs.dialog = {

    // メッセージダイアログを表示
    showMsg: function(title, msg, callback) {
        this.show(title, 200, 300, this.msgHTML(msg), callback);
    },

    // 友人一覧ダイアログを表示
    showfriendList: function(data) {
        this.show('あなたの友人一覧', 300, 300, this.friendListHTML(data));
    },

    // ユーザ単位の文字列登録情報ダイアログを表示
    showUserData: function(data) {
        this.show('登録されている文字列情報', 200, 300, this.userDataHTML(data));
    },

    show: function(title, height, width, html, callback) {
        var buttons = {};
        if (callback) {
            buttons = {"OK": callback};
        }
        var top  = Math.floor((600 - height) / 2);
        var left = Math.floor(($(window).width() - width) / 2);
        $('#result-dialog').empty();
        $('#result-dialog').append(html);
        $('#result-dialog').dialog({
            title: title,
            height: height,
            width: width,
            resizable: false,
            position: [left, top],
            modal: true,
            buttons: buttons
        });
    },

    msgHTML: function(msg) {
        return $('<div>').text(msg);
    },

    friendListHTML: function(data) {
        var ul = $('<ul>').attr('class', 'myfriendList');
        $.each(data.entry, function(i, item){
            $('<li>').attr('class', 'myfriend').append(
                $('<a>').attr('href', '#').append(
                    $('<img>').attr('src', item.thumbnailUrl)
                )
            ).append(
                $('<span>').text(item.displayName)
            ).appendTo(ul);
        });
        return ul;
    },

    userDataHTML: function(data) {
        var div = $('<div>');
        $.each(data.entry, function(i, item){
            var ul = $('<ul>');
            $.each(item.data, function(key, value){
                $('<li>').text('key: ' + key).appendTo(ul);
                $('<li>').text('value: ' + value).appendTo(ul);
            });
            $('<div>').text('userId: ' + item.id).appendTo(div);
            ul.appendTo(div);
        });
        return div;
    }
};


