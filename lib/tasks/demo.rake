namespace :demo do

  desc "Initialize SlaDock demo status"

  task initial: :environment do

    # 找到既有的 workspace 並刪除 channel, message, directmsg, third-table (有 dependent destroy 會自動刪除)
    Workspace.find_by(name: "AAA公司").try(:destroy)
    # 找到既有的 user 並刪除
    User.where(email: ["111@111.111", "222@222.222", "333@333.333", "444@444.444", "555@555.555"]).try(:destroy_all)



    # 建立 WS：AAA公司
    ws = Workspace.create(name: "AAA公司")
    # 建立 CH：HEAD、GitHub_Msg
    ws.channels.create([
                        { name: "general" },
                        { name: "HEAD" },
                        { name: "GitHub_Msg" }
                      ])
    
    # 建立 User：「老闆」、「主管」、「新人」、「同事1」、「同事2」
    users = User.create([
            { nickname: "老闆", email: "111@111.111", password: "111111", confirmed_at: Time.now },
            { nickname: "主管", email: "222@222.222", password: "222222", confirmed_at: Time.now },
            { nickname: "新人", email: "333@333.333", password: "333333", confirmed_at: Time.now },
            { nickname: "同事1", email: "444@444.444", password: "444444", confirmed_at: Time.now },
            { nickname: "同事2", email: "555@555.555", password: "555555", confirmed_at: Time.now }
          ])
    
    # 建立 CatBot User
    if User.where(nickname: "CatBot").blank?
      User.create(nickname: "CatBot", email: "catbot@sladock.tw", password: "password", confirmed_at: Time.now)
    end
    catbot = User.find_by(nickname: "CatBot")

    # WS 加入所有 Users
    ws.users = users
    ws.users << catbot

    # CH general(all), GitHub_Msg(all), HEAD(老闆、主管)
    ws.channels.find_by(name: "general").users = users
    ws.channels.find_by(name: "GitHub_Msg").users = users
    ws.channels.find_by(name: "GitHub_Msg").users << catbot
    ws.channels.find_by(name: "HEAD").users = User.where(nickname: ["老闆", "主管"])

    # Msg 專案事項(HEAD)
    boss = User.find_by(nickname: "老闆")
    boss.channels.find_by(name: "HEAD").messages.create(user_id: boss.id, content: "【專案分工】<br>
                                                                                    10/30 完成以下工作項目<br>
                                                                                    同事1：開發串接第三方服務<br>
                                                                                    同事2：開發留言回覆串功能<br>
                                                                                    新人：開發訊息分享功能"
                                                       )

    # # 串第三方的所有設定
    manager = User.find_by(email: "222@222.222")
    ch_github = ws.channels.find_by(name: "GitHub_Msg")
    payload_url = "https://staging.sladock.tw/webhook/channels/#{ch_github.id}/github"
    manager.webhook_records.create(webhook_name: "GitHub_demo", repo_name: "SlackClone/slack", channel_id: ch_github.id, secret: "123456", payload_url: payload_url)
    
    puts "payload_url: #{payload_url}"

    # 最後需要什麼
    # workspace：AAA公司
    # Channel：general(all), HEAD(老闆、主管), GitHub_Msg(all)
    # User：「老闆」、「主管」、「新人」(還沒加入WS)、「同事1」、「同事2」「CatBot」
    # Message：專案事項(HEAD)
    # 第三方：串好 Github 在 GitHub_Msg 有通知

  end
end