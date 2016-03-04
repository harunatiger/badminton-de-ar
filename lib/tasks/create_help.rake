namespace :helptopic do
  desc "create records to HelpCategory"
  task create: :environment do
    help_categories = []
    root1 = HelpCategory.create({'id' => 1,'name_ja' => "その他のQ&A",'name_en' => "Other Q&A",'parent_id' => nil})
    root2 = HelpCategory.create({'id' => 2,'name_ja' => "ガイドのQ&A",'name_en' => "Guide Q&A",'parent_id' => nil})
    child1 = root1.children.create({'id' => 3, 'name_ja' => "はじめに",'name_en' => "Getting started",'parent_id' => 1})
    child2 = root1.children.create({'id' => 4,'name_ja' => "新規登録",'name_en' => "Sign up",'parent_id' => 1})
    child3 = root1.children.create({'id' => 5,'name_ja' => "プロフィール管理",'name_en' => "Manage your profile",'parent_id' => 1})
    child3_1 = child3.children.create({'id' => 6,'name_ja' => "プロフィール",'name_en' => "Profile",'parent_id' => 5})
    child3_2 = child3.children.create({'id' => 7,'name_ja' => "認証",'name_en' => "Verification",'parent_id' => 5})
    child3_3 = child3.children.create({'id' => 8,'name_ja' => "退会",'name_en' => "Quit",'parent_id' => 5})
    child4 = root1.children.create({'id' => 9,'name_ja' => "セキュリティ＆パスワード",'name_en' => "Security&Password",'parent_id' => 1})
    child5 = root1.children.create({'id' => 10,'name_ja' => "言語&通貨",'name_en' => "Language&Currency",'parent_id' => 1})
    child6 = root1.children.create({'id' => 11,'name_ja' => "ツアー予約までの流れ",'name_en' => "Booking a tour",'parent_id' => 1})
    child7 = root1.children.create({'id' => 12,'name_ja' => "ツアーのキャンセル",'name_en' => "Tour cancel",'parent_id' => 1})
    child8 = root1.children.create({'id' => 13,'name_ja' => "ツアー体験",'name_en' => "Experience",'parent_id' => 1})
    child9 = root2.children.create({'id' => 14,'name_ja' => "ガイドをはじめる前に",'name_en' => "Before you start guide",'parent_id' => 2})
    child10 = root2.children.create({'id' => 15,'name_ja' => "ツアーを作る",'name_en' => "Make your tour",'parent_id' => 2})
    child10_1 = child10.children.create({'id' => 16,'name_ja' => "事前準備",'name_en' => "Be ready for making tour",'parent_id' => 15})
    child10_2 = child10.children.create({'id' => 17,'name_ja' => "ツアー登録",'name_en' => "Create a tour",'parent_id' => 15})
    child10_3 = child10.children.create({'id' => 18,'name_ja' => "紹介画像・動画",'name_en' => "Pictures and movie for your tour",'parent_id' => 15})
    child10_4 = child10.children.create({'id' => 19,'name_ja' => "料金・条件",'name_en' => "Price and condition",'parent_id' => 15})
    child10_5 = child10.children.create({'id' => 20,'name_ja' => "ツアーを公開する",'name_en' => "Publish tour",'parent_id' => 15})
    child11 = root2.children.create({'id' => 21,'name_ja' => "ガイドする",'name_en' => "Start guide",'parent_id' => 2})
    child12 = child11.children.create({'id' => 22,'name_ja' => "ガイド",'name_en' => "Guide",'parent_id' => 21})
    child13 = child11.children.create({'id' => 23,'name_ja' => "レビュー",'name_en' => "Review",'parent_id' => 21})
    child14 = child11.children.create({'id' => 24,'name_ja' => "代金の受取",'name_en' => "Receive your guide reward",'parent_id' => 21})
    child15 = root2.children.create({'id' => 25,'name_ja' => "ガイドの退会",'name_en' => "Quit guide",'parent_id' => 2})

    help_topics = []
    help_topics << {
     'id' => 1, 'help_category_id' => 3, 'order_num' => 1,
     'title_ja' => 'TOMODACHI GUIDEとは？',
     'title_en' => 'What is TOMODACHI GUIDE?',
     'body_ja' => "日本を訪れる外国人旅行者の方々を、英語を学びたい日本人が「友達を持て成すように」ガイドする、新感覚ガイドマッチングサービスです。
主に大学生が中心となり、Huber.の無料アカウントを作り、普段の自分たちの遊びを、ツアーとして登録している、とてもユニークなサービスです。",
      'body_en' => "TOMODACHI GUIDE is new matching service between foreign tourists and Japanese people who want to study and show their local experience.
With university students as the main users, it is a unique service where you can make a free account and sign up to make tours of your everyday hangouts.    "
    }
    help_topics << {
     'id' => 2, 'help_category_id' => 3, 'order_num' => 2,
     'title_ja' => 'TOMODACHI GUIDEの特徴は？',
     'title_en' => 'What is feature of TOMODACHI GUIDE',
     'body_ja' => '①地元ならではの、今までにないツアーがいっぱい
ありきたりの観光名所巡りではなく、そこに住む人たちの暮らしぶりが垣間見れる体験を提供します。地元の人しか知らない隠れた名店も、実際にその町に住むTOMODACHI GUIDEなら沢山知っています。

②一緒に楽しむ体験
ツアー自体ではなく、それをキッカケとした交流や共感にこそ価値があると私たちは信じています。普通のガイドではなく、一緒に遊ぶ体験。それがTOMODACHI GUIDEです。

③友だちになることから始める旅
TOMODACHI GUIDEは、英語が学びたい日本人大学生が中心となってサービスを提供しています。彼らは皆さんとの交流にとても前向きです。どんどん相談して交流し仲良くなってください。そうすればきっと、ツアーは最高に楽しい体験になるはずです。',
     'body_en' => '1. Many unique tours only possible with people who have a deep knowledge of the local area
Our service offers truly local experiences you can see only in that  area, not only conventional tourist spots.
Your TOMODACHI GUIDE can guide you to cool hidden restaurants that only local people know about.

2. Sharing experience
We believe that not only the tour itself but the communication with new people that happens through the tour is valuable.
TOMODACHI GUIDE is not a normal guide, but a sharing experience.

3. Make a tour and start your trip
TOMODACHI GUIDE is a platform where the main users are university students who want to learn English. They are really excited to meet you. Talk with them, ask them about Japan and then become closer with them. This will make your trip the best it can be.'
    }
    help_topics << {
     'id' => 3, 'help_category_id' => 3, 'order_num' => 3,
     'title_ja' => 'ツアー申込みまでの流れ',
     'title_en' => 'How it works',
     'body_ja' => "①Find trips for you
      TOMODACHI GUIDE are waiting with unique plans for you

      ②Discuss and book!
      It all starts with a conversation! Your TOMODACHI GUIDE will customize your tour based on your preferences

      ③START YOUR TRIP
      Enjoy local experiences with TOMODACHI GUIDE
      Don't feel confined to the plan and feel free to be spontaneous on your trip!",
           'body_en' => "①Find trips for you
      TOMODACHI GUIDE are waiting with unique plans for you

      ②Discuss and book!
      It all starts with a conversation! Your TOMODACHI GUIDE will customize your tour based on your preferences

      ③START YOUR TRIP
      Enjoy local experiences with TOMODACHI GUIDE
      Don't feel confined to the plan and feel free to be spontaneous on your trip!"
    }
    help_topics << {
     'id' => 4, 'help_category_id' => 3, 'order_num' => 4,
     'title_ja' => 'ツアーが終わったら',
     'title_en' => 'After you finish tour',
     'body_ja' => "TOMODACHI GUIDEたちは、あなたを満足させられたかどうか、とても気になっていると思います。ツアー終了後にはレビュー依頼のメールが送られますので、あなたなりに感じたツアーの評価を伝えてあげてください。それが彼らのモチベーションになります。",
     'body_en' => "TOMODACHI GUIDEs really want to make sure they can offer the best tours. After the tour, please give a review to your guide. This will help them in future tours."
    }
    help_topics << {
     'id' => 5, 'help_category_id' => 4, 'order_num' => 1,
     'title_ja' => 'アカウントを作成するにはどうすればいいですか？',
     'title_en' => 'How can I sign up',
     'body_ja' => "Huber.のアカウントをお持ちでない方は<a href='http://localhost:3000/users/sign_up'>こちら</a>から登録できます。
利用登録はメールアドレスだけでなく、Facebookに接続して済ますこともできます。Huber.アカウントの作成は完全に無料です。

登録が済んだら、必ずプロフィールを作成しておきましょう。",
     'body_en' => "If you don't have a Huber account, you can sign up <a href='http://localhost:3000/users/sign_up'>here</a>.
You can make an account with an email address or Facebook account.
You can make a Huber account for free.

After you finish making your account, please complete your profile."
    }
    help_topics << {
     'id' => 6, 'help_category_id' => 6, 'order_num' => 1,
     'title_ja' => 'Account infomationって何ですか？',
     'title_en' => 'What is Account information?',
     'body_ja' => "プロフィール情報の記入項目欄への情報追加状況の進捗を示しています。",
     'body_en' => "It shows how much you proceed to enter your information."
    }
    help_topics << {
     'id' => 7, 'help_category_id' => 7, 'order_num' => 1,
     'title_ja' => 'ID認証ってなんですか？',
     'title_en' => 'What is ID verification?',
     'body_ja' => "ID認証はHuber.のプロフィールをFacebookのプロフィールやお電話番号、メールアドレス、写真入り身分証明書などの個人情報と繋げ、本人確認をする機能です。",
     'body_en' => "ID verification is a function to confirm your identity by connecting your private information with your Facebook account, phone number, email address and official photo ID."
    }
    help_topics << {
     'id' => 8, 'help_category_id' => 7, 'order_num' => 2,
     'title_ja' => '認証済みIDとは何ですか？',
     'title_en' => 'What is verified ID?',
     'body_ja' => "「認証済みID取得プロセス」は、コミュニティ内部の信頼を高め、ゲスト・ホストともに安心してサービスを利用できるサービスとするために導入しています。

◼︎認証済みID取得の流れ
ID認証は、Huber.のプロフィールを他の情報元と照会することで行われます。ID認証に際しては、Huber.から次のようなことをお願いすることがあります。

１．政府発行の写真付き身分証明書（パスポートなど）のスキャン画像をアップロードすること
２．Facebookなどの外部アカウントのオンライン・プロフィールとHuber.アカウントを連携させること
３．Huber.アカウントのプロフィールに顔写真をアップロードし、電話番号とメールアドレスを入力すること

◼︎認証完了はどんな時に必要？
サイトでは一定の状況下で、ID認証完了を要求されます。
◼︎非公開だから安心
Huber.ではプライバシー保護の重要性を真摯に受け止めています。
ID認証でお預かりする政府発行の身分証明書や個人情報はガイドにもゲストにも絶対教えません。先方には単に認証プロセスが無事完了したとお伝えするだけです。また、アカウント連携後もFacebookなど外部サイトに何かを、あなたの許可なしに投稿することは決してありません。

◼︎終わると認証済みIDのバッジがつきます
認証済みID取得プロセスが完了すると、プロフィールにバッジが表示されます。ガイドもゲストもツアー予約の可否を決める際にはこのバッジの有無をチェックする人が意外と多いんですよ。
",
     'body_en' => "The process to approve user ID improves trust for the Huber community and means both guests and guides can use our service with ease.

*Process to approve user ID
Your ID is approved by checking your profile against other information. We might ask you for the following things to approve your ID.

1. Upload your ID with your face picture issued by goverment (eg. passport)
2. Connect your account with another account such as Facebook.
3. Upload your an ID photo and enter your phone number and email address.

*When do I need to have my ID approved?
Under certain conditions, our website will ask for members with approved ID.
*Stable security with private identification
Huber treats privacy protection with the utmost importance.
Your ID information is perfectly safe from others. Your ID is not disclosed to your guide.
In addition, Huber will never make posts on your behalf if you connect your account to Facebook.

*When your ID is approved, your profile will show ID confirmation.
When your ID is approved, your profile will display your ID confirmed status. Both guests and guides care about whether or not your ID is approved when they decide to book the tour."
    }
    help_topics << {
     'id' => 9, 'help_category_id' => 7, 'order_num' => 3,
     'title_ja' => 'メール通知が届きません。なぜ？',
     'title_en' => "Why can't I recieve notification?",
     'body_ja' => "◼︎メールアドレスに間違いがないかチェック
宛先が古いアドレス、間違ったアドレスになっているのかもしれません。送信先アドレスは以下の方法でチェックできます。
「マイアカウント > Account > E-mail address」とクリック
メールアドレスの項目を探し、アドレスが合ってるかチェック。
もし間違っていたら、正しいアドレスを入力し、ページの一番下で「Change E-mail address」をクリックします

◼︎メールのフィルター（スパムなど）をチェック
スパムと間違えて迷惑メールのフォルダやごみ箱に仕分けてしまったのかも。これを避けるには以下の対策を。

Huber.から届くメールを迷惑メールリストからはずします。
アドレス帳に次のアドレスを追加します:Huber.（noreply@huber-japan.com）
そのほかにも、メールアカウントのフィルターや経路指定ルールで、Airbnbからのメールがどこか別の場所にソートされている可能性もありますので、そちらも確かめてみましょう。

◼︎メールのサービスプロバイダに相談
プロバイダによってはメールの配信に何時間もかかる場合もあります。メールの未達や遅れが続く場合は、アカウントに影響を与える設定ミスやネットワーク障害が起こってないか、プロバイダに問い合わせてみましょう。",
     'body_en' => '*Is there a mistake with your email address?
Your email address might be old or registered incorrectly.
You can check your registered address in the following way.
My account>Account>E-mail address
In this page, you can find and check your registered e-mail address.
If it is an incorrect e-mail address, enter the right email address and then click "Change e-mail address" below on the screen.

* Check your email folder(eg. Junk email folder)
Emails from Huber might accidentally get sorted into the Junk email folder.
'
    }
    help_topics << {
     'id' => 10, 'help_category_id' => 8, 'order_num' => 1,
     'title_ja' => '退会するには？',
     'title_en' => "How to quit",
     'body_ja' => "マイページのAccount内にある退会欄から手続きが可能です。
ツアー予約がされている状態で退会手続きを行うと、すべてのツアーはキャンセルポリシーに則り、キャンセルされます。
ツアー実施１４日以内でのキャンセルについては、キャンセル手数料が発生しますので、詳しくはサービス規約をご確認ください。

＊ガイドの退会の場合は条件が変わりますので、「ガイドの退会」をご覧ください。",
     'body_en' => 'You can delete your account in the "Account" section of your page.
If you quit with bookings still active, your bookings will be cancelled based on our cancellation policy.
You will be charged a cancellation fee if you cancel less than 14 days before your tour.

*Please be aware that there are different conditions for deletion of a guide account. Refer to "Deletion of Guide Accounts" for more details.'
    }
    help_topics << {
     'id' => 11, 'help_category_id' => 9, 'order_num' => 1,
     'title_ja' => 'パスワードを再設定するにはどうすればいいですか？',
     'title_en' => "How can I reset my password?",
     'body_ja' => "１．ログイン時の画面で「Forgot your password?」をクリックします。
２．次の画面で、登録したメールアドレスを入力します。
３．届いたメール内のリンク「Changing password」をクリックします。
４．新しいパスワードを再設定し、完了。",
     'body_en' => '1. Click "Forget your password?"
2. Enter your registered email address in the next page
3. When you receive the email from Huber, follow the link to change your password.
4. Reset new password'
}
    help_topics << {
     'id' => 12, 'help_category_id' => 9, 'order_num' => 2,
     'title_ja' => 'Huber.登録メールアドレスの変更方法は？',
     'title_en' => "How can I change email address registered on Huber?",
     'body_ja' => "１．マイアカウントの「Profile」をクリック
２．「E-mail address」をクリック
３．Change E-mail address 欄にて、新しいメールアドレスを入力
４．画面下部の「Change E-mail address」をクリックし、完了。",
     'body_en' => '1. Click "Profile" in your account.
2. Click "Email address"
3. Enter new email address in "Change email address"
4. Click "Change email address" on the screen below.'
    }
    help_topics << {
     'id' => 13, 'help_category_id' => 10, 'order_num' => 1,
     'title_ja' => '支払いはどの通貨でも大丈夫？',
     'title_en' => "Is any currency available?",
     'body_ja' => "ツアーの料金の支払いは、円建てでの支払いになります。",
     'body_en' => "Guide price is paid by Japanese yen,"
    }
    help_topics << {
     'id' => 14, 'help_category_id' => 10, 'order_num' => 2,
     'title_ja' => '為替レートはどのように計算されますか？',
     'title_en' => "How is currency rate culculated?",
     'body_ja' => "当社はPayPal決済を採用しております。お支払で使用する通貨（予約の通貨）が円以外の通貨の場合、PayPal内の独自為替レートにて換算され支払われます。詳しくはPayPal内のQ&Aをご参照ください。",
     'body_en' => "Huber uses PayPal for payments. If you use a currency other than Japanese yen, your currency will be exchanged to Japanese yen in PayPal and paid to your guide.
Please check the PayPal Q&A for detail."
    }
    help_topics << {
     'id' => 15, 'help_category_id' => 11, 'order_num' => 1,
     'title_ja' => '魅力的なツアーを探しましょう',
     'title_en' => "Look for attractive tour for you",
     'body_ja' => "エリア、カテゴリ、ガイド…様々な方法で検索が可能です。
あなたのニーズにマッチしたツアーを探してみましょう。",
     'body_en' => "You can search for tours from various criteria such as location, category and guide.
Find the best tour to suit your needs. "
    }
    help_topics << {
     'id' => 16, 'help_category_id' => 11, 'order_num' => 2,
     'title_ja' => 'お気に入りの作成＆管理',
     'title_en' => "Make and manage your favorites",
     'body_ja' => "ツアー、またはガイドページに「ハート」マークがありますよね？
これをクリックすることで、マイページ内の「favorite」に登録されます。とても便利ですよ！",
     'body_en' => "Can you see the heart icon on tour pages and guide pages?
Add tours and guides to your favorites by clicking the heart."
    }
    help_topics << {
     'id' => 17, 'help_category_id' => 11, 'order_num' => 3,
     'title_ja' => '￥0のツアーって無料なの？',
     'title_en' => "Is free tour really free?",
     'body_ja' => "TOMODACHI GUIDEはセミオーダータイプのガイドサービスです。
相談しながらガイドがツアー内容を決め、最終的な金額を提示されたのち、それに合意することで予約が完了します。
￥０円のサービスの多くは「相談無料のフルオーダーツアー」が大半ですので、最終的に費用が発生することになるものが大半です。
詳しくはツアー詳細を確認し、担当ガイドに確認してみましょう。",
     'body_en' => "TOMODACHI GUIDE serve you flexible tour.
Talking with guide and guest about trip and after that, bothof them agree with the tour information, then booking is completed.
Many of free tours are flexible tours for you that those guide receive your questions and requests, so most of them will have some price for guide.
Check tour information in detail and contact those guides."
    }
    help_topics << {
     'id' => 18, 'help_category_id' => 11, 'order_num' => 4,
     'title_ja' => 'まずは相談しよう',
     'title_en' => "Send message to your favorite guide",
     'body_ja' => "TOMODACHI GUIDEは、国際交流を望む人たちです。彼らは皆さんからの連絡を待っています。
旅のプランニングの際にわからないこと、不安なこと、当日ツアーに参加する人数、あなたの趣味や興味などを担当ガイドに伝えましょう。
きっとあなたに合った素晴らしいツアーを考えてくれます。",
     'body_en' => "TOMODACHI GUIDE is "
    }
    help_topics << {
     'id' => 19, 'help_category_id' => 11, 'order_num' => 5,
     'title_ja' => 'カスタマイズしよう',
     'title_en' => "Customize a tour",
     'body_ja' => "TOMODACHI GUIDEは、セミオーダー型のガイドサービスです。
一概にツアーと言っても、あなたのニーズ、参加する人数や構成によってカスタマイズしたくなることが多いと思います。
そんな要望があったら、どんどん担当ガイドに伝えて、ツアーをカスタマイズしてもらいましょう。",
     'body_en' => "TOMODACHI GUIDE is "
    }
    help_topics << {
     'id' => 20, 'help_category_id' => 11, 'order_num' => 6,
     'title_ja' => '予約申込みと支払い',
     'title_en' => "Booking and payment",
     'body_ja' => "相談して納得のいくツアーになったら、ガイド側からオファーがきます。
それを承諾すると、PayPalの支払い画面が立ち上がるので、必要情報を入力し支払いを済ませましょう。
決済にあたっては、PayPalアカウントやクレジットカードが必要となります。",
     'body_en' => "Your guide can offer you a booking after both guide and guest have agreed to with the tour contents.  After you approve the booking offer, you will be directed to a payment screen. Please enter the necessary information and finish your payment.
You will need a PayPal account or a credit card."
    }
    help_topics << {
     'id' => 21, 'help_category_id' => 11, 'order_num' => 7,
     'title_ja' => 'サービス料とはなんですか？',
     'title_en' => "What is service commission?",
     'body_ja' => "当サービスの利用料となります。またこの中には、決済手数料や為替手数料などの諸費用も含まれております。",
     'body_en' => "There is a service commission for using our service.
The service commission includes a commission fee for transactions and currency exchanges."
    }
    help_topics << {
     'id' => 22, 'help_category_id' => 11, 'order_num' => 8,
     'title_ja' => 'クーポンコードとは何ですか？',
     'title_en' => "What is coupon code?",
     'body_ja' => "所定のクーポンコードを入力して予約を申込むことで、一定条件を満たすと割引やキャッシュバックを受けることができます。
詳しくはクーポンコードに付随する解説をご確認ください。",
     'body_en' => "You can get discounts or cashback if you book a tour with a coupon code.
Please check the terms of your coupon code for details."
    }
    help_topics << {
     'id' => 23, 'help_category_id' => 11, 'order_num' => 9,
     'title_ja' => 'ツアー予約をしたが、支払い画面が出てきません',
     'title_en' => "Payment screen doesn't come up even though I booked tour",
     'body_ja' => "TOMODACHI GUIDEは、旅行者の方に最良の体験を提供するため、相談して納得してから申込みを頂く流れになっています。メッセージのやり取りの中でツアー内容がFixしたら、ガイドからオファーが届きますので、それを承認すればお支払い画面に移行します。",
     'body_en' => "In TOMODACHI GUIDE service, the guest and guide discuss the contents of the tour in advance through messages in order to provide the best tour. You can book the tour after both have agreed with the tour contents.
You can go to payment screen after you approve the offer."
    }
    help_topics << {
     'id' => 24, 'help_category_id' => 12, 'order_num' => 1,
     'title_ja' => 'キャンセル方法',
     'title_en' => "How to cancel",
     'body_ja' => "マイページ内の「Message＞TourInformation」か、「Your Trips」から、ツアーのキャンセルを行うことができます。
ツアー実施１４日以内となってからのキャンセルについては、キャンセル手数料が発生しますのでご注意ください。
詳しくはサービス規約をご確認ください。",
     'body_en' => 'You can cancel the tour in the "Your Trip" page, or in the "Tour Information" page in the "Message" section of your page.
Please be aware that a cancelation fee will be charged if you cancel 14 days or less before the tour.
Please check our service policy for details.'
    }
    help_topics << {
     'id' => 25, 'help_category_id' => 12, 'order_num' => 2,
     'title_ja' => 'キャンセル料金はいつから発生しますか？',
     'title_en' => "When is cancellation commission charged?",
     'body_ja' => "ツアー実施１４日前からキャンセル手数料が発生します。詳しくはサービス規約をご確認ください。
またすべてのキャンセル時には、PayPalのキャンセル手数料等を差し引いた金額が返金されます。ご注意ください。",
     'body_en' => "A cancellation fee will be charged if you cancel 14 days or less before the tour. Please check our service policy for details.
After your refund is authorized, you will receive your payment minus any cancellation commissions by PayPal.
"
    }
    help_topics << {
     'id' => 26, 'help_category_id' => 12, 'order_num' => 3,
     'title_ja' => '雨天の場合はどうなりますか？',
     'title_en' => "How is tour going on bad weather?",
     'body_ja' => "ツアーごとに異なります。
各ツアー詳細にある「In the case of rainy weather」をご確認ください。

「雨天中止」が前提条件として設定されているツアーについて、当日雨でツアー実行を
見送りたい場合は、自分でキャンセル申請は行わず、必ず担当ガイドに相談してください。
あなたからの連絡を受け、「雨天によるツアー提供の中止」を担当ガイドが判断した場合
ガイド側からのキャンセルを条件に、キャンセル手数料の負担なくキャンセルできます。",
     'body_en' => 'It depends on tours.
Please check "In the case of rainy weather" in tour page for details.
Please first ask your guide if you want to cancel the tour because of rainy weather. If your guide agrees to cancel the tour due to rainy weather, you can cancel the tour without being charged a cancellation fee.'
    }
    help_topics << {
     'id' => 27, 'help_category_id' => 12, 'order_num' => 4,
     'title_ja' => 'キャンセル時に発生する手数料',
     'title_en' => "Commission on cancellation",
     'body_ja' => "ツアー終了後、Huber.よりゲスト向けにレビュー及び評価の依頼メールが送信されます。ゲストがレビューの登録を完了したらガイドにもレビュー及び評価の依頼メールが届きます。双方が登録し終えた段階でサイト上に公開されます。お互いのレビューと評価を見れるのは公開されてからになります。",
     'body_en' => "Please check the cancellation policy.
When you cancel the tour and get refunded, please be aware that a cancellation commission by PayPal is subtracted from your refunded money."
    }
    help_topics << {
     'id' => 28, 'help_category_id' => 13, 'order_num' => 1,
     'title_ja' => 'ツアー中の予定変更はできますか？',
     'title_en' => "Can I change itinerary on the tour on the day?",
     'body_ja' => "可能です。TOMODACHI GUIDEサービスは、食事代、交通費、入場料などの「個人にかかる経費」はすべて自己負担となっています。
だからこそ、旅先での急な要望変更にも、柔軟に対応することができます！
ただしガイドの費用もガイドの自己負担なので、想定外の高級店に入りたくなった場合「このお店は高すぎて入れない」と涙することがあります。
その際は「じゃあ、僕が出してあげるよ！」という気前の良さでガイドを助けてあげてください。",
     'body_en' => "You can. In TOMODACHI GUIDE service, guides and guests cover their own costs such as food, transportation and entrance fee by themselves. This is why they can offer you flexible tours."
    }
    help_topics << {
     'id' => 29, 'help_category_id' => 13, 'order_num' => 2,
     'title_ja' => '当日ガイドと連絡が取れなかったら？',
     'title_en' => "In the case that I can't contact guide in the day",
     'body_ja' => "Huber.の問合せ窓口まで詳細をご連絡ください。",
     'body_en' => "Contact us for more details
+81-467-95-8742
guide_support@m.huber.co.jp"
    }
    help_topics << {
     'id' => 30, 'help_category_id' => 14, 'order_num' => 1,
     'title_ja' => 'TOMODACHI GUIDEとの旅が楽しい３つ理由',
     'title_en' => "Three Reasons to Choose TOMODACHI GUIDE",
     'body_ja' => "1.楽しいへのミート率が上がる　（or 未知との遭遇を楽しめる）

観光ガイド本に載っている外国人向けのアトラクションやレストランではなく、地元の人間に愛されるところに行ってみたいと思いませんか？
TOMODACHI GUIDEと一緒なら、あなたはポピュラーな観光地はもちろん、地元の人間でなきゃ知らない場所や遊びに出会うことでしょう。英語が通じないからという理由で外国の方々に紹介されていない素晴らしいレストラン、英語の地図には詳しく表記されていない素敵な散歩道や絶景ポイントがたくさんあります。
もし事前にあなたのやりたいことや食べたいものなどをTOMODACHI GUIDEと相談しておけば、その確率は格段にアップするでしょう。
そして実際の旅では、TOMODACHI GUIDE は常にペアであなたをサポートしますので、旅の途中で思いついたことや、発見してもっと知りたくなったことなどにフレキシブルに対応できます。
つまり、あなたは旅行という限られた時間を最大限にあなたらしく楽しむことができるでしょう。

2.たくさんのエピソードが生まれる （or たくさんのエピソードに出会える）

建物や景色を見る旅も良いですが、思い出に残るのって人との出会いだったりしませんか？
TOMODACHI GUIDE はあなたに会うこと、交流することを楽しみにしている人間の集まりです。
あなたをどうやって楽しませようかを考え、あなたがどうしたいのかを感じ取ろうとするでしょう。
あなたが喜ぶことは、他の大勢の方が喜ぶことと同じではないでしょうから、画一的な案内をするのではなく、あなたの気持ちに歩調を合わせるでしょう。
でもTOMODACHI GUIDE はガイドだけを仕事にしている人間ではありませんから、プロの通訳ガイドのように英語で案内することに慣れていないかもしれません。多くの外国の方が喜ぶ一般的な情報を持っていないかもしれません。
その代わりに、あなたの思いを英語でちゃんと汲み取れる人間と、英語はそこそこでもあなたの知りたい情報に詳しい人間がペアを組みあなたをサポートします。
そしてTOMODACHI GUIDE は皆、友達を大切にすることが大好きな人間です。地元にそれぞれの大切にしている繋がりがあって、行く先々で出逢う人々に、あなたを友人として紹介するでしょう。
旅が終わる頃にはきっと、あなたはたくさんの出会いの思い出を手にしていることでしょう。

3.自分のインスピレーションに素直でいられる（or やりたいことに素直でいられる）

情報不足や言葉の壁のせいで、楽しい体験を逃してしまうなんてもったいないと思いませんか？
私たちは、せっかくあなたが旅行先として日本を選んでくれたのに、そんなの絶対にもったいない！と思います。
TOMODACHI GUIDE は、宿泊先選び、クルマの手配や運転、アトラクションやレストランの予約、観光のスケジューリング、もちろんあなたの気分や体調に合わせてリスケジュールすることも、きっといっしょに楽しみます。
もしそういったことをビジネスとして請け負う執事のような者を旅先であなたが雇うとしたら、とても高額になるでしょう。リーズナブルなパッケージで提案してくれるツアー会社のプランだと、あなたらしく自由に行動はできないでしょう。
一方で、あなたに日本の素晴らしさを知って欲しかったり、あなたと交流することでグローバルな感覚を磨きたいと思っている日本人はたくさんいるのです。友人としての信頼関係が成立すれば、あなたにとって負担になってしまうことを自分の楽しみとして行える、そんな人間がTOMODACHI GUIDEにたくさん参加しています。
まずはあなたと気が合いそうなTOMODACHI GUIDEに話しかけてみてください。それからは簡単、いっしょにあなたらしい旅を計画し、ワクワクしながら日本へと飛んできてください！",
     'body_en' => "Three Reasons to Choose TOMODACHI GUIDE

1. More chances of enjoying yourself!

Do you feel like doing more than merely visiting the tourist attractions/restaurants listed in guidebooks, and want to discover places only local people know about? With TOMODACHI GUIDE, you can do just that: enjoy places and things most travelers miss out on, while also visiting the more obvious and popular tourist spots. So many great restaurants aren't listed in traditional guides because their staff can’t speak English, and plenty of beautiful locations that offer nice walks and amazing views just don't appear on English maps. If there’s something in particular you would like to do or specialties you feel like trying, simply tell your TOMODACHI GUIDE beforehand to boost your chances of doing so. During your actual trip, TOMODACHI GUIDE will always be with you and ready to help out, so feel free to be spontaneous! TOMODACHI GUIDE will flexibly adapt to your requests if there’s anything that you think of during your trip, if you want to find out more about something you’ve discovered, and so on. In other words, you can make the most out of the limited amount of time you have and enjoy a highly personalized trip!

2. More great adventures!
A trip is more than just discovering new places and enjoying the scenery, it’s about the memories you make and the people you meet. TOMODACHI GUIDEs are people who are keen on making friends and helping them have a good time. They think about the best ways to enjoy an area and try to get an idea of what you might like to do. Not everybody likes the same things, so instead of coming up with a standardized plan, your TOMODACHI GUIDEs will suggest a unique plan custom-made for you. TOMODACHI GUIDEs aren’t necessarily full-time guides, so they might not be used to showing you around using perfect English like professional interpreter-guides, and might not know every little detail that can be found in guidebooks. To compensate for this, TOMODACHI GUIDEs work in pairs: one guide takes care of communicating in English and making the trip you envisioned a reality while the other one (less proficient at English) will give you all the information you may want. TOMODACHI GUIDEs truly value friendship, and will introduce you as their friend to acquaintances of theirs that you might meet at the various places you visit together. By the time your trip is over, no doubt you will have lots of unforgettable memories of people you met in Japan.

3. More ideas for your trip!
It’s too bad you have to miss out on so many fun experiences for reasons like lack of information and language barrier. You chose Japan as your travel destination, and should be able to make the most of it! TOMODACHI GUIDEs can help you with tricky arrangements like choosing your accommodation, renting a car and doing the driving, making reservations for special events and at restaurants, and planning out the sightseeing. TOMODACHI GUIDEs will adapt and organize the day’s schedule based on your mood and health condition so that together you can enjoy your time in Japan to the fullest. Hiring a professional for this kind of work would cost you a small fortune. Going on a group tour planned by a travel agency might be affordable, but it wouldn’t allow you as much freedom. TOMODACHI GUIDE gives you a new alternative: people interested in showing you Japan, its wonderful locations, features and activities. More and more Japanese people want to develop their global awareness by interacting with visitors such as yourself. TOMODACHI GUIDE is full of people who, once you’ve become friends and have built a relationship of trust, will gladly go the extra mile to give you a hand with troublesome matters. So why not start by getting in touch with a TOMODACHI GUIDE you share common interests with? From there on, it’s a piece of cake – all you need to do is plan out your special trip and jump on the plane, then you’re off to Japan!
"
    }
    help_topics << {
     'id' => 31, 'help_category_id' => 14, 'order_num' => 2,
     'title_ja' => 'TOMODACHI GUIDE ７つの心得',
     'title_en' => 'What is feature of TOMODACHI GUIDE',
     'body_ja' => "＜７つの心得＞

１ゲストの旅をリスペクトしよう
～相手の声に耳を傾けよう～
 ゲストは貴重な時間とお金をかけて日本に来ることを理解しておこう

２まず基本から（プロ意識を持とう）
～礼儀や基本知識は抑えておこう～
 まずは挨拶から、と同じように
最高な旅のはじまりは基本から。
サービスの土台は「基本」。

３お互いを知ろう
～友達になるきっかけ探し～
 お互いのことを知るのは距離を縮める魔法。友達になるには、まずはお互いを知り合おう。

４あなたは旅の演出家
～友の喜びは自分の喜び～
 あなたの気持ちを目に見える形で表現してあげよう！想いを演出に。

５一緒に楽しんじゃおう
～楽しみは伝播する～
　共有する時間は、お互いがつながる時間。ガイドが楽しむと、
ゲストも楽しくなる。
「楽しむ力」を解き放とう！

６ガイド同士も友であれ
～最高のコンビネーション～
役割分担がペアガイドのキモ。
１人は２人のために、
　２人はゲストのために。

７自分らしさを出そう
～Huber.は人が魅力～
　本当の自分を惜しみなく出すことで、あなたは丸裸になれる。
日本では「裸の付き合い」が親友になる必勝法なのだ。",
     'body_en' => "7 Rules to become a TOMODACHI GUIDE

1, Respect your guest's tour
~Listen to what your guest want to do~
Understand that your guests are spending their valuable time and money on their trip.

2, Start from basic manner(Be professional)
~Remember to have basic manners~
Remember to greet your guests when you meet people for the first time, these basics are necesssary for the best trip.
This will makes your trip better for your guest.

3, Know each other well
~Make opportunities to become friends~
Getting to know each other is the best way to be close to each other.
To become friends, know each other first.

4, You are the producer of your guest's trip
~Your friend's happiness is your happiness~
Express your hospitality in your tour! Produce the best trip for your guest.

5, Enjoy the trip together
~Share the happiness~
The time you share with your guest is the most important. Your guest will also be happy to see you enjoy the tour.

6, Know your support guide well
~Best cooperation between guides~
The most important tip to make your tour the best is cooperation between you and your support guide.
Support each other.

７Be yourself
~Your personality is your selling point in Huber~
　Show your real personality, don't try to change your behaviour.
In Japan, being honestly yourself is the best way to make friends."
    }
    help_topics << {
     'id' => 32, 'help_category_id' => 14, 'order_num' => 3,
     'title_ja' => 'どんな人がガイドになれるのですか？',
     'title_en' => "What kind of people can become guide?",
     'body_ja' => "前述の３つの理由、７つの心得に共感してくれる方で、
国際交流を楽しみたい方であれば、誰でもガイドになることができます。",
     'body_en' => "Anyone can become a TOMODACHI GUIDE as long as they agree with the above three reasons and the seven 心得, and want to participate in international exchange. "
    }
    help_topics << {
     'id' => 33, 'help_category_id' => 14, 'order_num' => 4,
     'title_ja' => 'なぜペアガイドなのでしょうか？',
     'title_en' => "Why two guides?",
     'body_ja' => "友だちをガイドするみたいでいいと言われても、初めての経験になるガイドは不安です。でも二人一緒だから心理的負担は1/2、やり遂げた喜びは２倍になります。協力・相談試合ながら対応できます。また１人が通訳、１人が案内、という役務を分担して負うことで、ペアならば合法的に、通訳案内士の国家資格がなくても有償で外国語ガイドができます。",
     'body_en' => "You might be anxious with your first time being a TOMODACHI GUIDE, but don't worry! With a support guide to help, your anixety will be less, and your joy of achievement will be even more than guiding by yourself!
You can cooperate and talk with your support guide.
Also, because you and your support guide can separate your roles between guide and translator, you can legally guide your guests even if you are not a licensed tour guide."
    }
    help_topics << {
     'id' => 34, 'help_category_id' => 14, 'order_num' => 5,
     'title_ja' => '法律や規制の面で気をつけるべきことは何ですか？',
     'title_en' => "What shold I care about in terms of law and leagal points?",
     'body_ja' => "前述の通り、ガイド実施時に１名が通訳の役割、１名が案内の役割を担うのであれば問題ありません。
ゲストにあった際に、お互いの主要の役割についてしっかり伝えるようにしましょう。",
     'body_en' => "As mentioned above, there is no problem if one guide take the role of interpreter and the other guide takes the role of guide.
When you meet your guests, it would be a good idea to explain this to them. "
    }
    help_topics << {
     'id' => 35, 'help_category_id' => 14, 'order_num' => 6,
     'title_ja' => '１人でもガイドできますか？',
     'title_en' => "Can I guide by myself?",
     'body_ja' => "TOMODACHI GUIDEとしてのサービス提供はできません。必ず２人１組でのガイド実施が必要となります。
Huber.はガイドパートナーを探すために、様々な仕組みを用意しておりますので、ぜひご活用頂き、素敵なパートナーを見つけてください。",
     'body_en' => "You can't guide your guests alone as a TOMODACHI GUIDE. You need to guide with your support guide. Huber prepares various systems for you to find your support guide, so please find a good partner with the use of our system."
    }
    help_topics << {
     'id' => 36, 'help_category_id' => 14, 'order_num' => 7,
     'title_ja' => 'どんな言語に対応していますか？',
     'title_en' => "Which language does Huber adopt?",
     'body_ja' => "Huber.は、英語が話せる訪日外国人旅行者と、英語を学びたい日本人のマッチングサービスです。
そのため、プラットフォームは英語でのコミュニケーションを前提としています。
対応言語として中国語・その他言語などをプロフィール表示は可能ですが、その他表示言語は「英語のみ」となっています。
※日本語でのプロフィール入力はできない仕組みになっていますので、ご了承ください。",
     'body_en' => "As Huber is a service to match English-speaking tourists and Japanese people who want to learn English, our platform recommends our users to use English.
Chinese and other languages are also available on your profile, but other sections are only available in English.
"
    }
    help_topics << {
     'id' => 37, 'help_category_id' => 14, 'order_num' => 8,
     'title_ja' => 'どんな人たちがお客様になるのですか？',
     'title_en' => "What kind of guest is in Huber?",
     'body_ja' => "英語が話せる多様なお客様がいらっしゃいます。
ターゲット像としては、ローカルな体験を好む好奇心旺盛で社交的なお客様が多いです。
言語は英語でも、それぞれの出身国によって価値観は様々ですので、しっかりおもてなしできるように、どんな食事が食べたいか？どんな体験がしたいのか？どんなことは避けたいか？など、ゲストとコミュニケーションをしっかりとって事前にリサーチを行いましょう。",
     'body_en' => "We have a wide range of customers who can speak English. Our target users are sociable and curious about local experiences.
Even though they speak English, cultural values are different in each country. In order to give your guest the best hospitality, communicate well with your guest about things such as what kind of food they want to eat, what kind of experiences they want to have, what they don't want to do during your tour."
    }
    help_topics << {
     'id' => 38, 'help_category_id' => 14, 'order_num' => 9,
     'title_ja' => '食事や交通費などは、ガイド代金に含みますか？',
     'title_en' => "Does guide price include food and transportation fees?",
     'body_ja' => "友だちと遊びに行く時、お金の払いは基本割り勘ですよね？
TOMODACHI GUIDEは、友だちをもてなすようなガイドサービスです。食事代や交通費、入場料など、各個人に発生する費用は各自負担となります。これによりツアーに規定されていない急な旅程変更にも対応できる柔軟性が生まれます。
旅行者の方から質問が来ることもあると思いますが、上記の考え方をお伝えして、当日かかる費用やその準備をお願いしておきましょう。",
     'body_en' => "When you hang out with your friends, you usually divide payment by the number of people.
TOMODACHI GUIDE is a service where Japanese people guide foreign tourists like a friend.
Food, transportation fees and other individual costs are covered by each person themselves in this service, which makes your tour flexible if you want to change your itinerary. Even though we assume that your guest will ask you about these costs on the day, you can tell your guest about this and ask your guests to prepare for cost on the day."
    }
    help_topics << {
     'id' => 39, 'help_category_id' => 14, 'order_num' => 10,
     'title_ja' => '英語はどの程度話せる必要がありますか？',
     'title_en' => "How fluently do I need to speak English?",
     'body_ja' => "日常会話ができれば問題ありません。言葉が通じなければ、通じた時の感動は人一倍になりますから。
でも自信がないなら、訪日外国人旅行者の方には「日常会話くらいは話せるよ」と、事前にしっかりその旨を伝えておきましょう。
そしてそれに納得してくれてるなら、あとは胸を張って、コミュニケーションを楽しみましょう。",
     'body_en' => "As long as you can speak conversational English, it is no problem. You will feel really happy when you succeed in expressing yourself in English.
If you are not confident with your English,  tell your guest that you can only speak conversational English and you can't speak more than that.
After both the guest and guide have agreed with that, you can enjoy communicating with your guest."
    }
    help_topics << {
     'id' => 40, 'help_category_id' => 14, 'order_num' => 11,
     'title_ja' => 'どんなツアーを作ったらいいですか？',
     'title_en' => "What kind of tuor shod I make?",
     'body_ja' => "いきなりツアーを作ると言われても難しいですよね？
でも友だちガイドは、自分の普段の遊びや興味をツアーにする、新感覚ガイドです。
いつもいく場所なら、トイレの場所も、急な天候不良でも、対応できますよね。
旅行者の方々は、皆さんのライフスタイルに興味を持つ方々ばかりです。
だから自然が一番。あなたのままでいいし、それがいいのです。",
     'body_en' => "It can be hard to make a tour at the beginning.
On the other hand, TOMODACHI GUIDE is a new style of guide where guides show guests their usual hangouts and hobbies.
You can respond to emergencies such as restroom breaks and sudden changes of weather in the places you know well.
Your guests are interested in your lifestyle, so just being natural is the most appealing for them."
    }
    help_topics << {
     'id' => 41, 'help_category_id' => 14, 'order_num' => 12,
     'title_ja' => 'ツアーの価格設定について',
     'title_en' => "About tour price setting",
     'body_ja' => "自分の普段の遊びに価値をつける、というのは難しいですよね。わかります。
ツアー時間や内容によりますが、ビギナーの方は１名あたり時給１０００円〜１５００円＋ガイド２名分の参加費用（交通費や食事代、入場料など）くらいを設定してみましょう。不安なら、TOMODACHI GUIDEの先輩や仲間に相談するのもいいです。そうやって何度か試してお客様の反応をみて、自信がついてきたら価格を調製していくのが好ましいです。",
     'body_en' => "We understand that it is really difficult to price your usual hangout.
Our beginner guides usually set their guide fee to about 1000~1500 yen per hour in addition to guide costs such as transportation fees, food, and entrance fees.
If you still feel worried about pricing your tour, you can ask your friends in TOMODACHI GUIDE. By getting more experience of guiding your guests, you can adjust and find out the best price for you and your guests."
    }
    help_topics << {
     'id' => 42, 'help_category_id' => 14, 'order_num' => 13,
     'title_ja' => 'システム手数料って何ですか？',
     'title_en' => "What is service commission?",
     'body_ja' => "Huber.のシステムを活用してガイドマッチングを行う場合、ガイド料金の14.5%のシステム手数料の支払いが必要となります。
この費用は、Huber.からガイドの皆様への銀行振込時に自動的に差し引かれます。詳しくはサービス規約をご確認ください。",
     'body_en' => "When you guide your guests through Huber platform, you are charged 14.5% in service commission.
This service commission will be charged when your guide fee goes into your bank account. Please check service policy for details."
    }
    help_topics << {
     'id' => 43, 'help_category_id' => 14, 'order_num' => 14,
     'title_ja' => 'TOMODACHI GUIDEに慣れてきたら',
     'title_en' => "When you get used to TOMODACHI GUIDE",
     'body_ja' => "経験を積んで、自信がついてきたら、面白いツアー作りに挑戦してみましょう。
TOMODACHI GUIDEはペアガイドです。例えば、プロの料理人さんと話をつけて料理体験を作ってみたり、農家の人と組んで農業体験のツアーを作ってみたり。留学生の友だちとペアになるのも楽しいですね。
組み合わせの数だけ、ツアーの多様性が広がりますね。そしてそれは、あなたにとっても素晴らしい体験になると思いますよ。",
     'body_en' => "After you get used to guiding and become more confident, try to make a unique tour.
TOMODACHI GUIDE is a pair guide service, so tours such as a cooking experience with professional cook, agricultural experience with local farmers, and experience wih foreign students will be unique and fun for guests.
The more combinations there are, the more diverse the tours become, which becomes a great experience."
    }
    help_topics << {
     'id' => 44, 'help_category_id' => 16, 'order_num' => 1,
     'title_ja' => 'アカウントを作ろう',
     'title_en' => "Make your account",
     'body_ja' => "サイト右上の「Sign up」をクリックすると、Facebook認証か、メールアドレス登録を行うことでアカウントを作成することができます。

⑴ Facebook認証での登録
Facebookにログインしている状態でクリックすると、必要情報を取得しアカウントが自動作成されます。

⑵ メールアドレスでの登録
任意のメールアドレスとパスワードを入力すると、設定したメールアドレス宛に認証用メールが送られます。そのメール内のURLをクリックすることで、アカウントが作成されます。",
     'body_en' => 'When you click "Sign up" on the top-right of the home page, you can make an account using your Facebook account or your email address.

(1)Sign up with Facebook account
When you click with the condition of logged in facebook, your account is automatically created by necessary information being automatically taken.

(2) Sign up with email address
After you submit your email address and password, a confirmation email is sent to your email address. Your account will be created when you click the URL in that email.'
    }
    help_topics << {
     'id' => 45, 'help_category_id' => 16, 'order_num' => 2,
     'title_ja' => 'プロフィール登録をしよう',
     'title_en' => "Register your profile",
     'body_ja' => "画面右上のニックネームをクリックすると、マイページ一覧が表示されます。その中の「Profile」をクリックすると、プロフィール設定画面となります。
プロフィール設定内容は下記の項目となります。ゲストの方に安心してもらうために、しっかりと入力を行いましょう。

General information
Introduction
My recipe for the perfect tour
Profile picture
ID information
銀行情報
",
     'body_en' => "When you click your nickname at the top-right of the page, your page is shown. When you click profile, the settings for your profile will be displayed.
You need to fill in the following sections to complete your profile

General information
Introduction
My recipe for the perfect tour
Profile picture
ID information
Bank Details"
    }
    help_topics << {
     'id' => 46, 'help_category_id' => 16, 'order_num' => 3,
     'title_ja' => '笑顔の写真を登録しよう',
     'title_en' => "Register your smiling face",
     'body_ja' => "マイページ内の「Profile」の「Profile picture」をクリックすると、カバー写真とプロフィール写真が設定できます。
写真には人柄が現れます。最高の笑顔を撮影して、世界中のゲストにPRしましょう！",
     'body_en' => 'When you click "Profile picture" in "Profile" of your page, you can set your cover photo and your profile picture.
Pictures show your personality. Show your guests a nice smile and appeal to guests all over the world.'
    }
    help_topics << {
     'id' => 47, 'help_category_id' => 16, 'order_num' => 4,
     'title_ja' => '支払先を登録しよう',
     'title_en' => "Register your bank account",
     'body_ja' => "マイページ内の「Profile」の「銀行情報」をクリックすると、入力フォームが表示されますので、必要情報を記入ください。
注意：この登録を完了するまではガイド料金は振り込まれません。ご了解ください。",
     'body_en' => 'Click "Bank Details" in "Profile" of your page to enter your bank information.
Attention: You cant have your guide fee paid to your bank account until you finish registering your bank details.'
    }
    help_topics << {
     'id' => 48, 'help_category_id' => 16, 'order_num' => 5,
     'title_ja' => '街へリサーチに出かけよう',
     'title_en' => "Go and reserch for your tour",
     'body_ja' => "Huber.は普段の自分の遊びをツアーにするサービスです。
だからこそ、行くはずだったお店が閉まっていたり、突然トイレに行きたいとなった場合などでも、対処ができるわけです。

ですが、ガイドをするという目線で、街を歩いてみるといろいろな発見があります。トイレの場所やツアー中に雨が降ってきた時の対処法方、ゲストとはぐれてしまった時の待ち合わせ場所などです。なので、ツアーを作る前には、一度下見に行くことをお勧めします。

また魅力を伝えるに写真は重要です。下見に合わせて、いろいろと見どころを決めて写真を撮影したり、動画を撮影したりしましょう。
海外の方は、あなたがどんな人柄の人かを知りたがっています。なので、写真にはあなたが写っているのが好ましいです。
セルフィー棒を使ったり、友達と一緒に行って、よい写真を沢山撮影しておきましょう。",
     'body_en' => "Huber is a service where you offer your usual hangout.
This is why you can be flexible even if a restaurant where you and your guests are planning to go is closed, and even if someone suddenly wants to go to the restroom.
But when you walk around your town from the point of view of a guide, you can find new things such as a location of a restroom, a way to escape from the rain, and a meeting place for if your guests get separated from you.

In order to show the attractiveness of your tour, pictures are also important. Take some pictures and movies when you go out to demonstrate your tour. "
    }
    help_topics << {
     'id' => 49, 'help_category_id' => 17, 'order_num' => 1,
     'title_ja' => '登録してみよう',
     'title_en' => "Register",
     'body_ja' => "マイページ内「Tour Page」へアクセスし、「Create a new tour」をクリックすることでツアー登録を開始することができます。
「ツアーページを作る」という画面に移行したら、アナウンスに従って登録を進めてください。必要な登録情報は…

　紹介文
　紹介画像・紹介動画
　料金・条件
　NG日の設定

となります。上記をすべて入力しましたら「この内容で公開する」ボタンを押してください。
これにより、作成されたツアーは公開され、Huber.サイト内に表示されるようになります。",
     'body_en' => 'You can start creating a new tour by clicking "Create a new tour" in "Tour Page" of your page.
When you go to create a new tour, proceed for the registration of your new tour following to the instructions.
You need the following information necessary to create a new tour
Introduction for your tour
Pictures and movie
Price and conditions
Unavailable schedule

When you have entered all the information above, click "Publish this tour"
Your tour will be published and publically displayed on the website.'
    }
    help_topics << {
     'id' => 50, 'help_category_id' => 17, 'order_num' => 2,
     'title_ja' => '日本語の入力ができません',
     'title_en' => "I can't type in Japanese",
     'body_ja' => "はい。仕様です。その通りです。
Huber.TOMODACHI GUIDEでは、世界最大の共通言語である「英語」でのコミュニケーションが前提となっています。
ですので、ツアープラン、プロフィールなど、ゲスト側に表示される部分は、英語以外の入力はできない仕様になっています。",
     'body_en' => "Yes, that's right.
As the most common language around the world, English is strongly recommended in Huber.TOMODACHI GUIDE. You can only use English on the tour page, profile and pages shown to guests."
    }
    help_topics << {
     'id' => 51, 'help_category_id' => 18, 'order_num' => 1,
     'title_ja' => '動画アップ時の容量制限はありますか？',
     'title_en' => "Is size for movie limited",
     'body_ja' => "はい、あります。最大で２５MBまでアップ可能です。
動画については、当社推奨の1sec Cameraか、SnapMovie（road movie maker）をご活用ください。",
     'body_en' => "Yes, it is. You can upload at most 25MB of video.
About movies on your tour, 1sec Camera, SnapMovie and <road movie maker> is recommended on our platform."
    }
    help_topics << {
     'id' => 52, 'help_category_id' => 18, 'order_num' => 2,
     'title_ja' => 'ツアーのイメージ画像を複数枚登録したいのですができますか？',
     'title_en' => "Is it possible to register some pitures on my tour",
     'body_ja' => "もちろん可能です。
Tour Page＞紹介画像・紹介動画＞ツアーのイメージ画像部分の「ファイルを選択」から、最大１０枚まで登録可能です。
また登録した写真の表示順番は、写真をドラックして移動させると順番が変わります。",
     'body_en' => 'Of course it is possible.
You can upload at most 10 pictures by " choose file" in "Pictures and movie" of Tour Page.
You can also change the order of pictures by dragging '
    }
    help_topics << {
     'id' => 53, 'help_category_id' => 19, 'order_num' => 1,
     'title_ja' => '所要時間が想定より長くなった場合、追加料金の請求はしても良いのでしょうか？',
     'title_en' => "In the case that length of tour time is longer than assumed,
is it ok to ask guest to pay me more?",
     'body_ja' => "取るも取らないもあなたの自由です。
ゲストとしっかりコミュニケーションをとって、双方合意の元、調整してください。",
     'body_en' => "It is up to you.
Please communicate with your guest and decide what you do with agreement from both you and your guest."
    }
    help_topics << {
     'id' => 54, 'help_category_id' => 19, 'order_num' => 2,
     'title_ja' => '当日予定よりも多くの人がきました。どうすればいいですか？',
     'title_en' => "On the day, more people than booked came to my tour.
How should I do?",
     'body_ja' => "どうするかはあなたの判断次第です。
ただ当然相手の人数が増えれば、サービスが行き届かなくなることも多くなります。
また参加人数に応じて費用が変わるものもあります。

大事なのは、約束していた条件が違うこと、十分なサービスが提供できないかもしれないこと、しっかりゲストに伝え、双方が同意することです。その上で実施するかしないか、判断しましょう。どうしても話が折り合わない場合は、Huber.スタッフまでご連絡ください。",
     'body_en' => "It is up to you.
When the number of people increases, it might be that your hospitality doesn't reach to all of them. The guide cost also changes depending on the number of people.
The important thing is to tell your guests and agree with your guests that you may not be able to give your guests enough hospitality when the conditions are different from ones you and your guests had on the website.
If you can't manage this kind of situation with your guest, please contact Huber staff."
    }
    help_topics << {
     'id' => 55, 'help_category_id' => 19, 'order_num' => 3,
     'title_ja' => '自動車やスペースレンタルをおこなうツアー',
     'title_en' => "Tour with car or rental space",
     'body_ja' => "自動車の利用料金、ガソリン代、駐車場料金など、グループ単位で発生する費用については、別途で設定する必要があります。
詳しくはツアー作成画面のガイダンスに従って登録を進めてください。

自動車料金の設定は、レンタル代金を入力。自家用車利用の場合は、必ず０円と設定してください。
ガソリン代については車種にもよりますが、ツアーでの概ねの走行距離を確認し、１Lあたりの走行距離から算定してください。
駐車場料金は、時間貸し駐車場の位置・料金を調べ、概ねの駐車時間を算定してください。

ツアーの内容や当日の急なスケジュール変更によって変動する場合は、ゲストにその旨を伝え、現金精算するようにしてください。",
     'body_en' => "You need to set costs per group such as car, gas, and parking lot if you use these in your tour. Please follow tour page when you set group costs.

Enter car cost if you use a rental car in your tour. Don't set a car cost if you use a car you own.
About the cost of gas, calculate how far you will drive and set a gas cost per liter.
About the cost of parking lot, set the price of the parking lot you are planning to use.

If those costs are likely to change due to your tour-plan or sudden changes of schedule, mention this and ask your guests to pay you on the day."
    }
    help_topics << {
     'id' => 56, 'help_category_id' => 19, 'order_num' => 4,
     'title_ja' => '２人にかかる費用って？',
     'title_en' => "What is guide cost?",
     'body_ja' => "ツアー提供にかかる費用は、事前にゲストへ請求しておくことができます。
TOMODACHI GUIDEは、ペアでのサービス提供が前提となっております。
なのでツアー提供に必要となる、２名分の交通費・食事代・入場料などをここに設定することが可能です。",
     'body_en' => "You can set guide costs for you and your support guide in advance.
You need to guide with support guide in TOMODACHI GUIDE so you can set costs for both guides."
    }
    help_topics << {
     'id' => 57, 'help_category_id' => 19, 'order_num' => 5,
     'title_ja' => 'スムーズに合流するには？',
     'title_en' => "To meet guest and guide smoothly",
     'body_ja' => "お互いに初めて会うのですから、工夫が必要な部分です。
例えば駅を指定する場合は、改札口名まで指定しましょう。（集合場所のメモなどにも記載しましょう）
また当日着ていく服の色や共通のサインを決めておく、また当日連絡がつく携帯番号を確認しておくなど、事前にゲストと調整しておきましょう。",
     'body_en' => "As both you and your guest will meet for the first time, you need to talk about the meeting place in detail.
For example, when you meet your guest at the station, decide which gate your guest should come to. (Write a note about the meeting place in the tour page)
Check in advance what color clothes you should wear on the day and your phone number."
    }
    help_topics << {
     'id' => 58, 'help_category_id' => 20, 'order_num' => 1,
     'title_ja' => 'ツアーを公開する',
     'title_en' => "Publish tour",
     'body_ja' => "すべての設定が完了したら、いよいよツアー公開！
「Tour page」左側の「この内容で公開する」ボタンを押すと、ツアーが一般公開されます。",
     'body_en' => 'Finally, publish your tour after you setting each condition for your tour.
When you click "Publish this tour" on the left side of screen in tour page, your tour will be publically displayed on the website.'
    }
    help_topics << {
     'id' => 59, 'help_category_id' => 20, 'order_num' => 2,
     'title_ja' => 'ツアーを非公開に戻すには',
     'title_en' => "To hide tour",
     'body_ja' => "ちょっと休みたいな、と思ったら、いつでもツアーを非公開にできます。
「Tour page」左側の「一時的に非公開にする」ボタンを押すと、ツアーが非公開になります。",
     'body_en' => 'If you decide that you want to have a break from guiding, you can hide your tour.
When you click "Unpublish this tour" on the left side of screen in the tour page, your tour will be hidden on the website.'
    }
    help_topics << {
     'id' => 60, 'help_category_id' => 22, 'order_num' => 1,
     'title_ja' => 'ツアー中のキャンセルについて',
     'title_en' => "Cancel",
     'body_ja' => "急な雨天や、当日のやむをえないトラブルのため、当日キャンセルが必要になってしまった場合は、急ぎHuber.スタッフへご連絡ください。
サービス規約 第１４条の２に則り、Huber.サイドにて判断を行い、トラブル対応・返金等の対応を行います。",
     'body_en' => "When you need to cancel your tour on the day due to bad weather or trouble on the day, please contact Huber staff quickly.
We will respond to any trouble and proceed refund according to the terms of service. "
    }
    help_topics << {
     'id' => 61, 'help_category_id' => 23, 'order_num' => 1,
     'title_ja' => 'レビューを書こう',
     'title_en' => "Rate your guest",
     'body_ja' => "Huber.では、ガイド・ゲストの相互評価システムを採用しています。
ツアーが無事完了したら、後日レビューメールがゲスト・ガイド双方に送られます。
体験の評価に加えて、体験について感じたこと、感謝の気持ちを、ぜひガイドに送ってあげてください。
それが彼らのモチベーションに繋がります。",
     'body_en' => "Huber uses a rating system for both guide and guest.
After you finish your tour, we will send an email to remind you to write a review for your guest or guide.
Don't only write a review, but also your thoughts about the tour experience, which will help to motivate your guide or guest in the future."
    }
    help_topics << {
     'id' => 62, 'help_category_id' => 24, 'order_num' => 1,
     'title_ja' => '支払いまでの流れ',
     'title_en' => "Proceed to payment",
     'body_ja' => "ゲストが支払ったガイド料金は、予約確定時に一旦Huber.のPayPal口座に振り込まれます。
その後、ツアー実施日の翌日までにキャンセル連絡がない場合は、ツアーが無事実行されたと判定され、支払い処理となります。
ガイド代金は毎週日曜日の23:59に集計され、14.5%のシステム手数料など必要経費を差し引いた金額が、その週の木曜日10:00に指定口座へ支払われます。詳しくはサービス規約をご確認ください。",
     'body_en' => "The guide price that your guest pays to you is transferred to the Huber PayPal account after the payment is authorized. After that, your guide reward will be properly authorized in your bank account if Huber doesn't receive cancellation from either guide or guest by the day after the tour.
Guide fee is calculated every Sunday at 23:59, and then the guide reward minus a 14.5% service commission will be sent to your bank account by 10:00am the following Thursday. See our service policy for more details. "
    }
    help_topics << {
     'id' => 63, 'help_category_id' => 24, 'order_num' => 2,
     'title_ja' => 'ガイド代金の受取',
     'title_en' => "Recieve guide price",
     'body_ja' => "銀行振込で行われます。マイページの「Profile」内、画面左側のタブ「銀行口座」をクリックすると、振込先口座を登録できます。",
     'body_en' => 'You can get your guide reward by bank transfer.
When you click "bank details" in "Profile" of your page, you can register your bank account.'
    }
    help_topics << {
     'id' => 64, 'help_category_id' => 25, 'order_num' => 1,
     'title_ja' => 'ガイドを退会するには？',
     'title_en' => "How to quit guide",
     'body_ja' => "マイページのAccount内にある退会欄から手続きが可能です。
ただしガイドとしてツアー予約を受けている状態では、退会を受け付けることはできません。
その場合、ゲストへツアーの予約キャンセルの旨を連絡し、ツアーのキャンセルを行うようにしてください。

またツアーキャンセルが発生する場合、ゲストへの迷惑に繋がる行為を防止するため、当社規定のキャンセルポリシーが適用されます。
第１５条の２「コンテンツの提供開始前におけるホストメンバーからのキャンセル」５項のペナルティが課される可能性がございますので、ご確認の上ご判断ください。",
     'body_en' => "You can delete your account from your page. You cannot delete your account if you have active bookings from guests. At that time, please contact your guests to ask about cancellation for your tour.

In the case of tour cancellation, our cancellation policy will be followed in order to prevent any inconvenience to the guest. There is a possibility that there will be a penalty as following Article 15-2 of the cancellation policy , so please check this before cancelling your tour. "
    }
    help_topics.each do |help_topics|
      HelpTopic.create(help_topics)
    end
  end
end
