qt5_add_resources(RESOURCES resources.qrc)
add_executable(plasma-phonebook
    main.cpp
    phonesmodel.cpp
    declarativeaddressee.cpp
    contactimporter.cpp
    imppmodel.cpp
    ${RESOURCES})
target_link_libraries(plasma-phonebook
        Qt5::Core Qt5::Qml Qt5::Quick Qt5::Svg
        KF5::Contacts KF5::People KF5::I18n
)

if(ANDROID)
    target_link_libraries(plasma-phonebook KF5::Kirigami2 Qt5::Svg Qt5::AndroidExtras)

    kirigami_package_breeze_icons(ICONS
        go-down-symbolic
        go-next-symbolic
        go-up-symbolic
        view-refresh
        search
        view-pim-contacts
        dialog-ok-apply
        dialog-cancel
        list-add
        list-remove
        list-add_executable
        contact-new-symbolic
        document-import
        mail-message
        call-start
        document-edit
        delete
        # im-* icons used by KContacts::Impp::serviceIcon
        im-google
        im-gadugadu
        im-twitter
        im-irc
        im-google-talk
        im-yahoo
        im-jabber
        im skype
        im-icq
        im-qq
        im-facebook
        im-aim
        im-identi.ca
        im-youtube
    )

endif()

install(TARGETS plasma-phonebook ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

add_subdirectory(kpeopleactionplugin)
