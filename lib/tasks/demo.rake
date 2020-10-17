namespace :demo do

  desc "Initialize SlaDock demo status"

  task initial: :environment do

    # 找到既有的 workspace 並刪除 channel, message, directmsg, third-table (有 dependent destroy 會自動刪除)
    Workspace.find_by(name: "百倍紅寶石").try(:destroy)
    # 找到既有的 user 並刪除
    User.where(email: ["111@111.111", "reid@sladock.tw", "ruby@sladock.tw", "444@444.444", "555@555.555"]).try(:destroy_all)



    # 建立 WS：百倍紅寶石
    ws = Workspace.create(name: "百倍紅寶石")
    # 建立 CH：HEAD、GitHub_Msg
    ws.channels.create([
                        { name: "general" },
                        { name: "HEAD" },
                        { name: "GitHub_Msg" }
                      ])
    
    # 建立 User：「龍哥」、「主管-仁傑」、「Ruby」、「Keddie」、「Sabrina」
    users = User.create([
            { nickname: "龍哥", email: "111@111.111", password: "111111", confirmed_at: Time.now },
            { nickname: "主管-仁傑", email: "reid@sladock.tw", password: "222222", confirmed_at: Time.now },
            { nickname: "Keddie", email: "444@444.444", password: "444444", confirmed_at: Time.now },
            { nickname: "Sabrina", email: "555@555.555", password: "555555", confirmed_at: Time.now }
          ])

    newbie = User.create( nickname: "Ruby", email: "ruby@sladock.tw", password: "333333", confirmed_at: Time.now )
    
    # 建立 CatBot User
    if User.where(nickname: "CatBot").blank?
      User.create(nickname: "CatBot", email: "catbot@sladock.tw", password: "password", confirmed_at: Time.now)
    end
    catbot = User.find_by(nickname: "CatBot")

    # WS 加入所有 Users
    ws.users = users
    ws.users << catbot

    # CH general(all), GitHub_Msg(all), HEAD(龍哥、主管-仁傑)
    ws.channels.find_by(name: "general").users = users
    ws.channels.find_by(name: "GitHub_Msg").users = users
    ws.channels.find_by(name: "GitHub_Msg").users << catbot
    ws.channels.find_by(name: "HEAD").users = User.where(nickname: ["龍哥", "主管-仁傑"])

    # Msg 專案事項(HEAD)
    boss = User.find_by(nickname: "龍哥")
    boss.channels.find_by(name: "HEAD").messages.create(user_id: boss.id, content: "【專案分工】<br>
                                                                                    10/30 完成以下工作項目<br>
                                                                                    Keddie：開發串接第三方服務<br>
                                                                                    Sabrina：開發留言回覆串功能<br>
                                                                                    Ruby：開發訊息分享功能"
                                                       )

    # 串第三方的所有設定
    user_reid = User.find_by(email: "reid@sladock.tw")
    ch_github = ws.channels.find_by(name: "GitHub_Msg")
    payload_url = "https://demo.sladock.tw/webhook/channels/#{ch_github.id}/github"
    user_reid.webhook_records.create(webhook_name: "GitHub_demo", repo_name: "SlackClone/slack", channel_id: ch_github.id, secret: "123456", payload_url: payload_url)

    puts "payload_url: #{payload_url}"

    # 最後需要什麼
    # workspace：百倍紅寶石
    # Channel：general(all), HEAD(龍哥、主管-仁傑), GitHub_Msg(all)
    # User：「龍哥」、「主管-仁傑」、「Ruby」(還沒加入WS)、「Keddie」、「Sabrina」「CatBot」
    # Message：專案事項(HEAD)
    # 第三方：串好 Github 在 GitHub_Msg 有通知

  end
end
