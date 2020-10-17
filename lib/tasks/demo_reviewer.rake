namespace :demo do

  desc "For reviewer : Initialize SlaDock demo status"

  task initial_reviewer: :environment do

    # 找到既有的 workspace 並刪除 channel, message, directmsg, third-table (有 dependent destroy 會自動刪除)
    Workspace.find_by(name: "ASTRO Camp Demo Day").try(:destroy)
    # 找到既有的 user 並刪除
    User.where(email: ["bernard@sladock.tw", "hitomi@sladock.tw", "milkmidi@sladock.tw", "backup@sladock.tw"]).try(:destroy_all)



    # 建立 WS：百倍紅寶石
    ws = Workspace.create(name: "ASTRO Camp Demo Day")
    # 建立 CH：HEAD、GitHub_Msg
    ws.channels.create([
                        { name: "general" },
                        { name: "HEAD" },
                        { name: "GitHub_Msg" }
                      ])
    
    # 建立 User：「龍哥」、「DC」、「Ruby」、「Keddie」、「Sabrina」
    users = User.create([
            { nickname: "Bernard", email: "bernard@sladock.tw", password: "bernard", confirmed_at: Time.now },
            { nickname: "Hitomi", email: "hitomi@sladock.tw", password: "hitomi", confirmed_at: Time.now },
            { nickname: "Milkmidi", email: "milkmidi@sladock.tw", password: "milkmidi", confirmed_at: Time.now },
            { nickname: "路人甲", email: "backup@sladock.tw", password: "backup", confirmed_at: Time.now }
          ])
    
    # 建立 CatBot User
    if User.where(nickname: "CatBot").blank?
      User.create(nickname: "CatBot", email: "catbot@sladock.tw", password: "password", confirmed_at: Time.now)
    end
    catbot = User.find_by(nickname: "CatBot")

    # WS 加入所有 Users
    ws.users = users
    ws.users << catbot

    # CH general(all), GitHub_Msg(all), HEAD(龍哥、DC)
    ws.channels.find_by(name: "general").users = users
    ws.channels.find_by(name: "GitHub_Msg").users = users
    ws.channels.find_by(name: "GitHub_Msg").users << catbot
    ws.channels.find_by(name: "HEAD").users = User.where(nickname: ["Bernard", "Hitomi", "Milkmidi"])

    # Msg 專案事項(HEAD)
    boss = User.find_by(nickname: "Milkmidi")
    boss.channels.find_by(name: "general").messages.create(user_id: boss.id, content: "大家好，我是奶綠茶"
                                                       )
    puts "Finished"

  end
end