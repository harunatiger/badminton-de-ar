# == Route Map
#
#                                  Prefix Verb       URI Pattern                                                         Controller#Action
#                  new_admin_user_session GET        /admin/login(.:format)                                              active_admin/devise/sessions#new
#                      admin_user_session POST       /admin/login(.:format)                                              active_admin/devise/sessions#create
#              destroy_admin_user_session DELETE|GET /admin/logout(.:format)                                             active_admin/devise/sessions#destroy
#                     admin_user_password POST       /admin/password(.:format)                                           active_admin/devise/passwords#create
#                 new_admin_user_password GET        /admin/password/new(.:format)                                       active_admin/devise/passwords#new
#                edit_admin_user_password GET        /admin/password/edit(.:format)                                      active_admin/devise/passwords#edit
#                                         PATCH      /admin/password(.:format)                                           active_admin/devise/passwords#update
#                                         PUT        /admin/password(.:format)                                           active_admin/devise/passwords#update
#                              admin_root GET        /admin(.:format)                                                    admin/dashboard#index
#          batch_action_admin_admin_users POST       /admin/admin_users/batch_action(.:format)                           admin/admin_users#batch_action
#                       admin_admin_users GET        /admin/admin_users(.:format)                                        admin/admin_users#index
#                                         POST       /admin/admin_users(.:format)                                        admin/admin_users#create
#                    new_admin_admin_user GET        /admin/admin_users/new(.:format)                                    admin/admin_users#new
#                   edit_admin_admin_user GET        /admin/admin_users/:id/edit(.:format)                               admin/admin_users#edit
#                        admin_admin_user GET        /admin/admin_users/:id(.:format)                                    admin/admin_users#show
#                                         PATCH      /admin/admin_users/:id(.:format)                                    admin/admin_users#update
#                                         PUT        /admin/admin_users/:id(.:format)                                    admin/admin_users#update
#                                         DELETE     /admin/admin_users/:id(.:format)                                    admin/admin_users#destroy
#                batch_action_admin_auths POST       /admin/auths/batch_action(.:format)                                 admin/auths#batch_action
#                             admin_auths GET        /admin/auths(.:format)                                              admin/auths#index
#                                         POST       /admin/auths(.:format)                                              admin/auths#create
#                          new_admin_auth GET        /admin/auths/new(.:format)                                          admin/auths#new
#                         edit_admin_auth GET        /admin/auths/:id/edit(.:format)                                     admin/auths#edit
#                              admin_auth GET        /admin/auths/:id(.:format)                                          admin/auths#show
#                                         PATCH      /admin/auths/:id(.:format)                                          admin/auths#update
#                                         PUT        /admin/auths/:id(.:format)                                          admin/auths#update
#                                         DELETE     /admin/auths/:id(.:format)                                          admin/auths#destroy
#   batch_action_admin_browsing_histories POST       /admin/browsing_histories/batch_action(.:format)                    admin/browsing_histories#batch_action
#                admin_browsing_histories GET        /admin/browsing_histories(.:format)                                 admin/browsing_histories#index
#                                         POST       /admin/browsing_histories(.:format)                                 admin/browsing_histories#create
#              new_admin_browsing_history GET        /admin/browsing_histories/new(.:format)                             admin/browsing_histories#new
#             edit_admin_browsing_history GET        /admin/browsing_histories/:id/edit(.:format)                        admin/browsing_histories#edit
#                  admin_browsing_history GET        /admin/browsing_histories/:id(.:format)                             admin/browsing_histories#show
#                                         PATCH      /admin/browsing_histories/:id(.:format)                             admin/browsing_histories#update
#                                         PUT        /admin/browsing_histories/:id(.:format)                             admin/browsing_histories#update
#                                         DELETE     /admin/browsing_histories/:id(.:format)                             admin/browsing_histories#destroy
#          batch_action_admin_confections POST       /admin/confections/batch_action(.:format)                           admin/confections#batch_action
#                       admin_confections GET        /admin/confections(.:format)                                        admin/confections#index
#                                         POST       /admin/confections(.:format)                                        admin/confections#create
#                    new_admin_confection GET        /admin/confections/new(.:format)                                    admin/confections#new
#                   edit_admin_confection GET        /admin/confections/:id/edit(.:format)                               admin/confections#edit
#                        admin_confection GET        /admin/confections/:id(.:format)                                    admin/confections#show
#                                         PATCH      /admin/confections/:id(.:format)                                    admin/confections#update
#                                         PUT        /admin/confections/:id(.:format)                                    admin/confections#update
#                                         DELETE     /admin/confections/:id(.:format)                                    admin/confections#destroy
#                         admin_dashboard GET        /admin/dashboard(.:format)                                          admin/dashboard#index
#          batch_action_admin_dress_codes POST       /admin/dress_codes/batch_action(.:format)                           admin/dress_codes#batch_action
#                       admin_dress_codes GET        /admin/dress_codes(.:format)                                        admin/dress_codes#index
#                                         POST       /admin/dress_codes(.:format)                                        admin/dress_codes#create
#                    new_admin_dress_code GET        /admin/dress_codes/new(.:format)                                    admin/dress_codes#new
#                   edit_admin_dress_code GET        /admin/dress_codes/:id/edit(.:format)                               admin/dress_codes#edit
#                        admin_dress_code GET        /admin/dress_codes/:id(.:format)                                    admin/dress_codes#show
#                                         PATCH      /admin/dress_codes/:id(.:format)                                    admin/dress_codes#update
#                                         PUT        /admin/dress_codes/:id(.:format)                                    admin/dress_codes#update
#                                         DELETE     /admin/dress_codes/:id(.:format)                                    admin/dress_codes#destroy
#          batch_action_admin_emergencies POST       /admin/emergencies/batch_action(.:format)                           admin/emergencies#batch_action
#                       admin_emergencies GET        /admin/emergencies(.:format)                                        admin/emergencies#index
#                                         POST       /admin/emergencies(.:format)                                        admin/emergencies#create
#                     new_admin_emergency GET        /admin/emergencies/new(.:format)                                    admin/emergencies#new
#                    edit_admin_emergency GET        /admin/emergencies/:id/edit(.:format)                               admin/emergencies#edit
#                         admin_emergency GET        /admin/emergencies/:id(.:format)                                    admin/emergencies#show
#                                         PATCH      /admin/emergencies/:id(.:format)                                    admin/emergencies#update
#                                         PUT        /admin/emergencies/:id(.:format)                                    admin/emergencies#update
#                                         DELETE     /admin/emergencies/:id(.:format)                                    admin/emergencies#destroy
#             batch_action_admin_listings POST       /admin/listings/batch_action(.:format)                              admin/listings#batch_action
#                          admin_listings GET        /admin/listings(.:format)                                           admin/listings#index
#                                         POST       /admin/listings(.:format)                                           admin/listings#create
#                       new_admin_listing GET        /admin/listings/new(.:format)                                       admin/listings#new
#                      edit_admin_listing GET        /admin/listings/:id/edit(.:format)                                  admin/listings#edit
#                           admin_listing GET        /admin/listings/:id(.:format)                                       admin/listings#show
#                                         PATCH      /admin/listings/:id(.:format)                                       admin/listings#update
#                                         PUT        /admin/listings/:id(.:format)                                       admin/listings#update
#                                         DELETE     /admin/listings/:id(.:format)                                       admin/listings#destroy
#       batch_action_admin_listing_images POST       /admin/listing_images/batch_action(.:format)                        admin/listing_images#batch_action
#                    admin_listing_images GET        /admin/listing_images(.:format)                                     admin/listing_images#index
#                                         POST       /admin/listing_images(.:format)                                     admin/listing_images#create
#                 new_admin_listing_image GET        /admin/listing_images/new(.:format)                                 admin/listing_images#new
#                edit_admin_listing_image GET        /admin/listing_images/:id/edit(.:format)                            admin/listing_images#edit
#                     admin_listing_image GET        /admin/listing_images/:id(.:format)                                 admin/listing_images#show
#                                         PATCH      /admin/listing_images/:id(.:format)                                 admin/listing_images#update
#                                         PUT        /admin/listing_images/:id(.:format)                                 admin/listing_images#update
#                                         DELETE     /admin/listing_images/:id(.:format)                                 admin/listing_images#destroy
#          batch_action_admin_listing_pvs POST       /admin/listing_pvs/batch_action(.:format)                           admin/listing_pvs#batch_action
#                       admin_listing_pvs GET        /admin/listing_pvs(.:format)                                        admin/listing_pvs#index
#                                         POST       /admin/listing_pvs(.:format)                                        admin/listing_pvs#create
#                    new_admin_listing_pv GET        /admin/listing_pvs/new(.:format)                                    admin/listing_pvs#new
#                   edit_admin_listing_pv GET        /admin/listing_pvs/:id/edit(.:format)                               admin/listing_pvs#edit
#                        admin_listing_pv GET        /admin/listing_pvs/:id(.:format)                                    admin/listing_pvs#show
#                                         PATCH      /admin/listing_pvs/:id(.:format)                                    admin/listing_pvs#update
#                                         PUT        /admin/listing_pvs/:id(.:format)                                    admin/listing_pvs#update
#                                         DELETE     /admin/listing_pvs/:id(.:format)                                    admin/listing_pvs#destroy
#       batch_action_admin_listing_videos POST       /admin/listing_videos/batch_action(.:format)                        admin/listing_videos#batch_action
#                    admin_listing_videos GET        /admin/listing_videos(.:format)                                     admin/listing_videos#index
#                                         POST       /admin/listing_videos(.:format)                                     admin/listing_videos#create
#                 new_admin_listing_video GET        /admin/listing_videos/new(.:format)                                 admin/listing_videos#new
#                edit_admin_listing_video GET        /admin/listing_videos/:id/edit(.:format)                            admin/listing_videos#edit
#                     admin_listing_video GET        /admin/listing_videos/:id(.:format)                                 admin/listing_videos#show
#                                         PATCH      /admin/listing_videos/:id(.:format)                                 admin/listing_videos#update
#                                         PUT        /admin/listing_videos/:id(.:format)                                 admin/listing_videos#update
#                                         DELETE     /admin/listing_videos/:id(.:format)                                 admin/listing_videos#destroy
#             batch_action_admin_messages POST       /admin/messages/batch_action(.:format)                              admin/messages#batch_action
#                          admin_messages GET        /admin/messages(.:format)                                           admin/messages#index
#                                         POST       /admin/messages(.:format)                                           admin/messages#create
#                       new_admin_message GET        /admin/messages/new(.:format)                                       admin/messages#new
#                      edit_admin_message GET        /admin/messages/:id/edit(.:format)                                  admin/messages#edit
#                           admin_message GET        /admin/messages/:id(.:format)                                       admin/messages#show
#                                         PATCH      /admin/messages/:id(.:format)                                       admin/messages#update
#                                         PUT        /admin/messages/:id(.:format)                                       admin/messages#update
#                                         DELETE     /admin/messages/:id(.:format)                                       admin/messages#destroy
#      batch_action_admin_message_threads POST       /admin/message_threads/batch_action(.:format)                       admin/message_threads#batch_action
#                   admin_message_threads GET        /admin/message_threads(.:format)                                    admin/message_threads#index
#                                         POST       /admin/message_threads(.:format)                                    admin/message_threads#create
#                new_admin_message_thread GET        /admin/message_threads/new(.:format)                                admin/message_threads#new
#               edit_admin_message_thread GET        /admin/message_threads/:id/edit(.:format)                           admin/message_threads#edit
#                    admin_message_thread GET        /admin/message_threads/:id(.:format)                                admin/message_threads#show
#                                         PATCH      /admin/message_threads/:id(.:format)                                admin/message_threads#update
#                                         PUT        /admin/message_threads/:id(.:format)                                admin/message_threads#update
#                                         DELETE     /admin/message_threads/:id(.:format)                                admin/message_threads#destroy
# batch_action_admin_message_thread_users POST       /admin/message_thread_users/batch_action(.:format)                  admin/message_thread_users#batch_action
#              admin_message_thread_users GET        /admin/message_thread_users(.:format)                               admin/message_thread_users#index
#                                         POST       /admin/message_thread_users(.:format)                               admin/message_thread_users#create
#           new_admin_message_thread_user GET        /admin/message_thread_users/new(.:format)                           admin/message_thread_users#new
#          edit_admin_message_thread_user GET        /admin/message_thread_users/:id/edit(.:format)                      admin/message_thread_users#edit
#               admin_message_thread_user GET        /admin/message_thread_users/:id(.:format)                           admin/message_thread_users#show
#                                         PATCH      /admin/message_thread_users/:id(.:format)                           admin/message_thread_users#update
#                                         PUT        /admin/message_thread_users/:id(.:format)                           admin/message_thread_users#update
#                                         DELETE     /admin/message_thread_users/:id(.:format)                           admin/message_thread_users#destroy
#             batch_action_admin_profiles POST       /admin/profiles/batch_action(.:format)                              admin/profiles#batch_action
#                          admin_profiles GET        /admin/profiles(.:format)                                           admin/profiles#index
#                                         POST       /admin/profiles(.:format)                                           admin/profiles#create
#                       new_admin_profile GET        /admin/profiles/new(.:format)                                       admin/profiles#new
#                      edit_admin_profile GET        /admin/profiles/:id/edit(.:format)                                  admin/profiles#edit
#                           admin_profile GET        /admin/profiles/:id(.:format)                                       admin/profiles#show
#                                         PATCH      /admin/profiles/:id(.:format)                                       admin/profiles#update
#                                         PUT        /admin/profiles/:id(.:format)                                       admin/profiles#update
#                                         DELETE     /admin/profiles/:id(.:format)                                       admin/profiles#destroy
#       batch_action_admin_profile_images POST       /admin/profile_images/batch_action(.:format)                        admin/profile_images#batch_action
#                    admin_profile_images GET        /admin/profile_images(.:format)                                     admin/profile_images#index
#                                         POST       /admin/profile_images(.:format)                                     admin/profile_images#create
#                 new_admin_profile_image GET        /admin/profile_images/new(.:format)                                 admin/profile_images#new
#                edit_admin_profile_image GET        /admin/profile_images/:id/edit(.:format)                            admin/profile_images#edit
#                     admin_profile_image GET        /admin/profile_images/:id(.:format)                                 admin/profile_images#show
#                                         PATCH      /admin/profile_images/:id(.:format)                                 admin/profile_images#update
#                                         PUT        /admin/profile_images/:id(.:format)                                 admin/profile_images#update
#                                         DELETE     /admin/profile_images/:id(.:format)                                 admin/profile_images#destroy
#       batch_action_admin_profile_videos POST       /admin/profile_videos/batch_action(.:format)                        admin/profile_videos#batch_action
#                    admin_profile_videos GET        /admin/profile_videos(.:format)                                     admin/profile_videos#index
#                                         POST       /admin/profile_videos(.:format)                                     admin/profile_videos#create
#                 new_admin_profile_video GET        /admin/profile_videos/new(.:format)                                 admin/profile_videos#new
#                edit_admin_profile_video GET        /admin/profile_videos/:id/edit(.:format)                            admin/profile_videos#edit
#                     admin_profile_video GET        /admin/profile_videos/:id(.:format)                                 admin/profile_videos#show
#                                         PATCH      /admin/profile_videos/:id(.:format)                                 admin/profile_videos#update
#                                         PUT        /admin/profile_videos/:id(.:format)                                 admin/profile_videos#update
#                                         DELETE     /admin/profile_videos/:id(.:format)                                 admin/profile_videos#destroy
#         batch_action_admin_reservations POST       /admin/reservations/batch_action(.:format)                          admin/reservations#batch_action
#                      admin_reservations GET        /admin/reservations(.:format)                                       admin/reservations#index
#                                         POST       /admin/reservations(.:format)                                       admin/reservations#create
#                   new_admin_reservation GET        /admin/reservations/new(.:format)                                   admin/reservations#new
#                  edit_admin_reservation GET        /admin/reservations/:id/edit(.:format)                              admin/reservations#edit
#                       admin_reservation GET        /admin/reservations/:id(.:format)                                   admin/reservations#show
#                                         PATCH      /admin/reservations/:id(.:format)                                   admin/reservations#update
#                                         PUT        /admin/reservations/:id(.:format)                                   admin/reservations#update
#                                         DELETE     /admin/reservations/:id(.:format)                                   admin/reservations#destroy
#              batch_action_admin_reviews POST       /admin/reviews/batch_action(.:format)                               admin/reviews#batch_action
#                           admin_reviews GET        /admin/reviews(.:format)                                            admin/reviews#index
#                                         POST       /admin/reviews(.:format)                                            admin/reviews#create
#                        new_admin_review GET        /admin/reviews/new(.:format)                                        admin/reviews#new
#                       edit_admin_review GET        /admin/reviews/:id/edit(.:format)                                   admin/reviews#edit
#                            admin_review GET        /admin/reviews/:id(.:format)                                        admin/reviews#show
#                                         PATCH      /admin/reviews/:id(.:format)                                        admin/reviews#update
#                                         PUT        /admin/reviews/:id(.:format)                                        admin/reviews#update
#                                         DELETE     /admin/reviews/:id(.:format)                                        admin/reviews#destroy
#       batch_action_admin_review_replies POST       /admin/review_replies/batch_action(.:format)                        admin/review_replies#batch_action
#                    admin_review_replies GET        /admin/review_replies(.:format)                                     admin/review_replies#index
#                                         POST       /admin/review_replies(.:format)                                     admin/review_replies#create
#                  new_admin_review_reply GET        /admin/review_replies/new(.:format)                                 admin/review_replies#new
#                 edit_admin_review_reply GET        /admin/review_replies/:id/edit(.:format)                            admin/review_replies#edit
#                      admin_review_reply GET        /admin/review_replies/:id(.:format)                                 admin/review_replies#show
#                                         PATCH      /admin/review_replies/:id(.:format)                                 admin/review_replies#update
#                                         PUT        /admin/review_replies/:id(.:format)                                 admin/review_replies#update
#                                         DELETE     /admin/review_replies/:id(.:format)                                 admin/review_replies#destroy
#                batch_action_admin_tools POST       /admin/tools/batch_action(.:format)                                 admin/tools#batch_action
#                             admin_tools GET        /admin/tools(.:format)                                              admin/tools#index
#                                         POST       /admin/tools(.:format)                                              admin/tools#create
#                          new_admin_tool GET        /admin/tools/new(.:format)                                          admin/tools#new
#                         edit_admin_tool GET        /admin/tools/:id/edit(.:format)                                     admin/tools#edit
#                              admin_tool GET        /admin/tools/:id(.:format)                                          admin/tools#show
#                                         PATCH      /admin/tools/:id(.:format)                                          admin/tools#update
#                                         PUT        /admin/tools/:id(.:format)                                          admin/tools#update
#                                         DELETE     /admin/tools/:id(.:format)                                          admin/tools#destroy
#                batch_action_admin_users POST       /admin/users/batch_action(.:format)                                 admin/users#batch_action
#                             admin_users GET        /admin/users(.:format)                                              admin/users#index
#                                         POST       /admin/users(.:format)                                              admin/users#create
#                          new_admin_user GET        /admin/users/new(.:format)                                          admin/users#new
#                         edit_admin_user GET        /admin/users/:id/edit(.:format)                                     admin/users#edit
#                              admin_user GET        /admin/users/:id(.:format)                                          admin/users#show
#                                         PATCH      /admin/users/:id(.:format)                                          admin/users#update
#                                         PUT        /admin/users/:id(.:format)                                          admin/users#update
#                                         DELETE     /admin/users/:id(.:format)                                          admin/users#destroy
#                          admin_comments GET        /admin/comments(.:format)                                           admin/comments#index
#                                         POST       /admin/comments(.:format)                                           admin/comments#create
#                           admin_comment GET        /admin/comments/:id(.:format)                                       admin/comments#show
#                  profile_profile_images GET        /profiles/:profile_id/profile_images(.:format)                      profile_images#index
#                                         POST       /profiles/:profile_id/profile_images(.:format)                      profile_images#create
#               new_profile_profile_image GET        /profiles/:profile_id/profile_images/new(.:format)                  profile_images#new
#              edit_profile_profile_image GET        /profiles/:profile_id/profile_images/:id/edit(.:format)             profile_images#edit
#                   profile_profile_image GET        /profiles/:profile_id/profile_images/:id(.:format)                  profile_images#show
#                                         PATCH      /profiles/:profile_id/profile_images/:id(.:format)                  profile_images#update
#                                         PUT        /profiles/:profile_id/profile_images/:id(.:format)                  profile_images#update
#                                         DELETE     /profiles/:profile_id/profile_images/:id(.:format)                  profile_images#destroy
#                                profiles GET        /profiles(.:format)                                                 profiles#index
#                                         POST       /profiles(.:format)                                                 profiles#create
#                             new_profile GET        /profiles/new(.:format)                                             profiles#new
#                            edit_profile GET        /profiles/:id/edit(.:format)                                        profiles#edit
#                                 profile GET        /profiles/:id(.:format)                                             profiles#show
#                                         PATCH      /profiles/:id(.:format)                                             profiles#update
#                                         PUT        /profiles/:id(.:format)                                             profiles#update
#                                         DELETE     /profiles/:id(.:format)                                             profiles#destroy
#                               dashboard GET        /dashboard(.:format)                                                dashboard#index
#      dashboard_host_reservation_manager GET        /dashboard/host_reservation_manager(.:format)                       dashboard#host_reservation_manager
#     dashboard_guest_reservation_manager GET        /dashboard/guest_reservation_manager(.:format)                      dashboard#guest_reservation_manager
#                         message_threads GET        /message_threads(.:format)                                          message_threads#index
#                                         POST       /message_threads(.:format)                                          message_threads#create
#                      new_message_thread GET        /message_threads/new(.:format)                                      message_threads#new
#                          message_thread GET        /message_threads/:id(.:format)                                      message_threads#show
#                                         PATCH      /message_threads/:id(.:format)                                      message_threads#update
#                                         PUT        /message_threads/:id(.:format)                                      message_threads#update
#                                         DELETE     /message_threads/:id(.:format)                                      message_threads#destroy
#                   send_message_messages POST       /messages/send_message(.:format)                                    messages#send_message
#                                messages GET        /messages(.:format)                                                 messages#index
#                                         POST       /messages(.:format)                                                 messages#create
#                             new_message GET        /messages/new(.:format)                                             messages#new
#                            edit_message GET        /messages/:id/edit(.:format)                                        messages#edit
#                                 message GET        /messages/:id(.:format)                                             messages#show
#                                         PATCH      /messages/:id(.:format)                                             messages#update
#                                         PUT        /messages/:id(.:format)                                             messages#update
#                                         DELETE     /messages/:id(.:format)                                             messages#destroy
#                         search_listings GET        /listings/search(.:format)                                          listings#search
#                  search_result_listings GET        /listings/search_result(.:format)                                   listings#search_result
#                                         GET        /listings/page/:page(.:format)                                      listings#index
#           manage_listing_listing_images GET        /listings/:listing_id/listing_images/manage(.:format)               listing_images#manage
#                  listing_listing_images POST       /listings/:listing_id/listing_images(.:format)                      listing_images#create
#                   listing_listing_image GET        /listings/:listing_id/listing_images/:id(.:format)                  listing_images#show
#                                         PATCH      /listings/:listing_id/listing_images/:id(.:format)                  listing_images#update
#                                         PUT        /listings/:listing_id/listing_images/:id(.:format)                  listing_images#update
#                                         DELETE     /listings/:listing_id/listing_images/:id(.:format)                  listing_images#destroy
#              manage_listing_dress_codes GET        /listings/:listing_id/dress_codes/manage(.:format)                  dress_codes#manage
#                     listing_dress_codes POST       /listings/:listing_id/dress_codes(.:format)                         dress_codes#create
#                      listing_dress_code GET        /listings/:listing_id/dress_codes/:id(.:format)                     dress_codes#show
#                                         PATCH      /listings/:listing_id/dress_codes/:id(.:format)                     dress_codes#update
#                                         PUT        /listings/:listing_id/dress_codes/:id(.:format)                     dress_codes#update
#                                         DELETE     /listings/:listing_id/dress_codes/:id(.:format)                     dress_codes#destroy
#              manage_listing_confections GET        /listings/:listing_id/confections/manage(.:format)                  confections#manage
#                     listing_confections POST       /listings/:listing_id/confections(.:format)                         confections#create
#                      listing_confection GET        /listings/:listing_id/confections/:id(.:format)                     confections#show
#                                         PATCH      /listings/:listing_id/confections/:id(.:format)                     confections#update
#                                         PUT        /listings/:listing_id/confections/:id(.:format)                     confections#update
#                                         DELETE     /listings/:listing_id/confections/:id(.:format)                     confections#destroy
#                    manage_listing_tools GET        /listings/:listing_id/tools/manage(.:format)                        tools#manage
#                           listing_tools POST       /listings/:listing_id/tools(.:format)                               tools#create
#                            listing_tool GET        /listings/:listing_id/tools/:id(.:format)                           tools#show
#                                         PATCH      /listings/:listing_id/tools/:id(.:format)                           tools#update
#                                         PUT        /listings/:listing_id/tools/:id(.:format)                           tools#update
#                                         DELETE     /listings/:listing_id/tools/:id(.:format)                           tools#destroy
#                         listing_publish GET        /listings/:listing_id/publish(.:format)                             listings#publish
#                       listing_unpublish GET        /listings/:listing_id/unpublish(.:format)                           listings#unpublish
#                                listings GET        /listings(.:format)                                                 listings#index
#                                         POST       /listings(.:format)                                                 listings#create
#                             new_listing GET        /listings/new(.:format)                                             listings#new
#                            edit_listing GET        /listings/:id/edit(.:format)                                        listings#edit
#                                 listing GET        /listings/:id(.:format)                                             listings#show
#                                         PATCH      /listings/:id(.:format)                                             listings#update
#                                         PUT        /listings/:id(.:format)                                             listings#update
#                                         DELETE     /listings/:id(.:format)                                             listings#destroy
#      reservation_reviews_review_replies POST       /reservations/:reservation_id/reviews/review_replies(.:format)      review_replies#create
#  new_reservation_reviews_review_replies GET        /reservations/:reservation_id/reviews/review_replies/new(.:format)  review_replies#new
# edit_reservation_reviews_review_replies GET        /reservations/:reservation_id/reviews/review_replies/edit(.:format) review_replies#edit
#                                         GET        /reservations/:reservation_id/reviews/review_replies(.:format)      review_replies#show
#                                         PATCH      /reservations/:reservation_id/reviews/review_replies(.:format)      review_replies#update
#                                         PUT        /reservations/:reservation_id/reviews/review_replies(.:format)      review_replies#update
#                                         DELETE     /reservations/:reservation_id/reviews/review_replies(.:format)      review_replies#destroy
#                     reservation_reviews POST       /reservations/:reservation_id/reviews(.:format)                     reviews#create
#                 new_reservation_reviews GET        /reservations/:reservation_id/reviews/new(.:format)                 reviews#new
#                edit_reservation_reviews GET        /reservations/:reservation_id/reviews/edit(.:format)                reviews#edit
#                                         GET        /reservations/:reservation_id/reviews(.:format)                     reviews#show
#                                         PATCH      /reservations/:reservation_id/reviews(.:format)                     reviews#update
#                                         PUT        /reservations/:reservation_id/reviews(.:format)                     reviews#update
#                                         DELETE     /reservations/:reservation_id/reviews(.:format)                     reviews#destroy
#                            reservations POST       /reservations(.:format)                                             reservations#create
#                             reservation GET        /reservations/:id(.:format)                                         reservations#show
#                                         PATCH      /reservations/:id(.:format)                                         reservations#update
#                                         PUT        /reservations/:id(.:format)                                         reservations#update
#                               wishlists GET        /wishlists(.:format)                                                wishlists#index
#                                         POST       /wishlists(.:format)                                                wishlists#create
#                            new_wishlist GET        /wishlists/new(.:format)                                            wishlists#new
#                           edit_wishlist GET        /wishlists/:id/edit(.:format)                                       wishlists#edit
#                                wishlist GET        /wishlists/:id(.:format)                                            wishlists#show
#                                         PATCH      /wishlists/:id(.:format)                                            wishlists#update
#                                         PUT        /wishlists/:id(.:format)                                            wishlists#update
#                                         DELETE     /wishlists/:id(.:format)                                            wishlists#destroy
#                        new_user_session GET        /users/sign_in(.:format)                                            users/sessions#new
#                            user_session POST       /users/sign_in(.:format)                                            users/sessions#create
#                    destroy_user_session DELETE     /users/sign_out(.:format)                                           users/sessions#destroy
#                 user_omniauth_authorize GET|POST   /users/auth/:provider(.:format)                                     users/omniauth_callbacks#passthru {:provider=>/facebook/}
#                  user_omniauth_callback GET|POST   /users/auth/:action/callback(.:format)                              users/omniauth_callbacks#:action
#                           user_password POST       /users/password(.:format)                                           users/passwords#create
#                       new_user_password GET        /users/password/new(.:format)                                       users/passwords#new
#                      edit_user_password GET        /users/password/edit(.:format)                                      users/passwords#edit
#                                         PATCH      /users/password(.:format)                                           users/passwords#update
#                                         PUT        /users/password(.:format)                                           users/passwords#update
#                cancel_user_registration GET        /users/cancel(.:format)                                             users/registrations#cancel
#                       user_registration POST       /users(.:format)                                                    users/registrations#create
#                   new_user_registration GET        /users/sign_up(.:format)                                            users/registrations#new
#                  edit_user_registration GET        /users/edit(.:format)                                               users/registrations#edit
#                                         PATCH      /users(.:format)                                                    users/registrations#update
#                                         PUT        /users(.:format)                                                    users/registrations#update
#                                         DELETE     /users(.:format)                                                    users/registrations#destroy
#                       user_confirmation POST       /users/confirmation(.:format)                                       users/confirmations#create
#                   new_user_confirmation GET        /users/confirmation/new(.:format)                                   users/confirmations#new
#                                         GET        /users/confirmation(.:format)                                       users/confirmations#show
#                             user_unlock POST       /users/unlock(.:format)                                             devise/unlocks#create
#                         new_user_unlock GET        /users/unlock/new(.:format)                                         devise/unlocks#new
#                                         GET        /users/unlock(.:format)                                             devise/unlocks#show
#                                    root GET        /                                                                   welcome#index
#

Rails.application.routes.draw do
  resources :listing_details

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :profiles do
    resources :profile_images
    resources :profile_banks
    resources :profile_identities
    member do
      get 'self_introduction',    action: 'self_introduction'
    end
  end

#  resources :auths

  get 'dashboard'                           => 'dashboard#index'
  get 'dashboard/host_reservation_manager'  => 'dashboard#host_reservation_manager'
  get 'dashboard/guest_reservation_manager' => 'dashboard#guest_reservation_manager'
  # get 'reviews'                             => 'profiles#review', as: 'user_review'
  # get 'introductions'                       => 'profiles#introduction', as: 'introduction'
  #get 'pickups/show/:type/:id'                    => 'listing_pickups#show', as: 'pickups_list'

  resources :message_threads, except: [:edit]

  resources :messages do
    collection do
      post 'send_message'
    end
  end

  resources :listings do
    collection do
      get 'search',        action: 'search'
      get 'search_result', action: 'search_result'
      get 'page/:page',    action: 'index'
    end
    resources :listing_images, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
      post 'update_all', on: :collection
    end
    resources :listing_details, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
    end
    #resources :listing_videos do
    #  get 'manage', on: :collection
    #end
    #resources :dress_codes, only: [:show, :create, :update, :destroy] do
    #  get 'manage', on: :collection
    #end
    #resources :confections, only: [:show, :create, :update, :destroy]  do
    #  get 'manage', on: :collection
    #end
    #resources :tools, only: [:show, :create, :update, :destroy] do
    #  get 'manage', on: :collection
    #end
    get 'publish',   action: 'publish',   as: 'publish'
    get 'unpublish', action: 'unpublish', as: 'unpublish'
    resources :ngevents, only: [:index, :create]
    resources :calendar
  end
  
  resources :pickups, only: [:show]
  
  resources :reservations, only: [:show, :edit, :create, :update] do
    resource :reviews do
      resource :review_replies
    end
    get 'confirm', on: :collection
    get 'cancel', on: :collection
  end

  resources :wishlists
  resources :ngevents, except: [:index, :create]

  devise_for :users, controllers: {
    sessions:            'users/sessions',
    registrations:       'users/registrations',
    passwords:           'users/passwords',
    omniauth_callbacks:  'users/omniauth_callbacks',
    confirmations:       'users/confirmations'
  }

  root 'welcome#index'
end
