import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "Constants.js" as Constants

Page {
    id: root

    property var statusbar_color    : main_frame.getCurrentColor();
    property string theme_color     : main.decToColor(statusbar_color);

    property bool avatar_changed : false;
    property bool block_buttons : false;

    property int href   :   1135;
    property int wref   :   720;
    property int cref   :   715;

    property int max_z  :   5;

    property int buttons_size           :   2*icons_size
    property int icons_size             :   (34/wref)*root.width;
    property int side_margin            :   (Constants.SIDE_FACTOR)*root.width;
    property int pad_buttons            :   (Constants.SPACING_FACTOR)*root.width;

    property int remaining_height       :   root.height-root.width;

    property int name_pixelsize         :  (70/href)*root.height;

    property int statuscontainer_height :   (5/8)*remaining_height;
    property int statuscontainer_y      :   root.height-(root.width+(remaining_height-statuscontainer_height)/2);

    property int statusindicator_pixelsize  :   (79/cref)*statuscontainer_height; //18,16,14
    property int statustext_pixelsize       :   (70/cref)*statuscontainer_height;
    property int statusdate_pixelsize       :   (53/cref)*statuscontainer_height;
    property int statusindicator_top_margin :   (statuscontainer_height/6)-statusindicator_pixelsize/2;
    property int statustext_top_margin      :   (5*statuscontainer_height/12)-statusindicator_pixelsize/2;
    property int left_margin                :   (1/15)*root.width;

    property int status_max_width           :   root.width-(3*left_margin+changestatus_button.width+separator.anchors.rightMargin);

    property int changestatusbutton_size    :   statustext_pixelsize;

    property int shadow_offset      :   root.height/200;

    property int text_box_width      :   status_max_width + (root.width-status_max_width)/2;
    property int text_box_height     :   statuscontainer_height;
    property int text_box_radius     :   text_box_width/128;
    property int text_box_y          :   (root.width-text_box_height)/2;
    property int text_box_x          :   (root.width-text_box_width)/2;
    property int text_box_buttons_height :   text_box_height/4;
    property string text_box_buttons_bg    :   theme_color.replace("#FF",("#"+Constants.ProfilePage.BUTTONS_BG_TRANSPARENCY));

    property int statusline_width           :   status_max_width;
    property int statusline_height          :   (4/cref)*remaining_height;
    property int statusline_top_margin      :   (1/4)*statustext_pixelsize;

    property int text_box_maxchars_pixelsize    :   (3/4)*statustext_pixelsize;
    property int text_box_maxchars_width        :   3*text_box_maxchars_pixelsize;


    function openRetoucher(image_source,transition_mode){
        root.StackView.view.push("qrc:/ImageProcessingPage.qml",
                                 {image_source : image_source},
                                 transition_mode);
    }

    Rectangle{
        id: background
        anchors.fill: parent
        color: Constants.ProfilePage.PADDING_COLOR
        z:-1
    }

    Connections{
        target: main_frame

        onStatusChanged:{
            status_text.text = new_status_gui;
            status_date.text = "Last updated " + new_date_gui;
        }

        onAvatarChanged:{
            profileimage.source = main_frame.getCurrentImagePath();
            statusbar_color = main_frame.getCurrentColor();
            avatar_changed = true;
        }

        onAvatarChanging:{
            openRetoucher(selected_image_path,StackView.Immediate);
        }

    }

    Rectangle{
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: main.toolbar_height
        color: "transparent"
        z: 1

        ToolButton {
            id: backbutton
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.left: parent.left
            anchors.leftMargin: side_margin;
            height: buttons_size
            width: buttons_size

            background: Rectangle{
                anchors.fill: parent
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT

                Image {
                    id: backicon
                    anchors.centerIn: parent
                    source: "icons/whitebackicon.png"
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked:{
                backbutton.action();
            }

            function action(){
                if(avatar_changed){
                    main_frame.sendAvatar();
                }
                root.StackView.view.pop();
            }
        }

        ToolButton {
            id: options_button
            anchors.top: parent.top
            anchors.topMargin: (parent.height-height)/2
            anchors.right: parent.right
            anchors.rightMargin: side_margin;
            height: buttons_size
            width: buttons_size

            background: Rectangle{
                anchors.fill: parent
                color: backbutton.pressed ? Constants.PRESSED_COLOR:Constants.TRANSPARENT

                Image {
                    id: optionsicon
                    anchors.centerIn: parent
                    source: "icons/whiteoptionsicon.png"
                    height: icons_size
                    width: icons_size
                }
            }

            onClicked:{
                options.open();
            }

        }
    }

    Rectangle{
        id: options
        height: (1-a)*options_button.height + (a)*max_height;
        width:  (1-a)*options_button.width + (a)*max_width;
        y:  (1-a)*options_button.y + (a)*max_y;
        x:  (1-a)*options_button.x + (a)*max_x;
        radius: width/128;
        color: Constants.MENU_COLOR;
        opacity: a*(Constants.MENU_TRANSPARENCY/0xFF);
        visible: enabled;
        enabled: a>(Constants.MENU_ENABLED_THRESHOLD);
        z: root.max_z;
        layer.enabled: true
        layer.effect: DropShadow{
            source: options
        }

        property real a             :   0;
        property int n_items        :   4;
        property int pixelsize      :   (Constants.MENUITEM_PIXEL_FACTOR/root.href)*root.height;
        property int vertical_pad   :   (Constants.MENU_VERTICALPAD_FACTOR)*pixelsize;
        property int max_height     :   n_items*(Constants.MENUITEM_HEIGHT_FACTOR)*pixelsize + 2*vertical_pad;
        property int max_width      :   (Constants.MENU_WIDTH_FACTOR)*root.width;
        property int item_height    :   (Constants.MENUITEM_HEIGHT_FACTOR)*pixelsize;
        property int item_width     :   max_width;
        property int border_margin  :   (Constants.MENU_BORDERMARGIN_FACTOR)*root.width;
        property int max_y          :   (border_margin);
        property int max_x          :   (root.width - (border_margin + max_width));



        function open(){
            open_menu.start();
        }

        function close(){
            close_menu.start();
        }

        PropertyAnimation{
            id: open_menu
            target: options
            property: "a"
            to: 1
            duration: Constants.MENU_TRANSITIONS_DURATION
        }

        PropertyAnimation{
            id: close_menu
            target: options
            property: "a"
            to: 0
            duration: Constants.MENU_TRANSITIONS_DURATION
        }

        Button{
            id: changeavatar_option
            anchors.top: parent.top
            anchors.topMargin: a*options.vertical_pad
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: changeavatar_option.height
                width: changeavatar_option.width
                color: changeavatar_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Change avatar"
                opacity: parent.a
            }

            onClicked: {
                changeavatar_button.action();
                options.close();
            }
        }

        Button{
            id: retouchavatar_option
            anchors.top: changeavatar_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: retouchavatar_option.height
                width: retouchavatar_option.width
                color: retouchavatar_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Edit avatar"
                opacity: parent.a
            }

            onClicked:{
                root.openRetoucher(profileimage.source,StackView.PushTransition);
                options.close();
            }
        }

        Button{
            id: changestatus_option
            anchors.top: retouchavatar_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: changestatus_option.height
                width: changestatus_option.width
                color: changestatus_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Update status"
                opacity: parent.a
            }

            onClicked:{
                changestatus_button.action();
                options.close();
            }
        }

        Button{
            id: managecontacts_option
            anchors.top: changestatus_option.bottom
            anchors.left: parent.left
            height: a*options.item_height
            width: a*options.item_width
            opacity: a

            property real a : options.a;

            background:Rectangle{
                height: managecontacts_option.height
                width: managecontacts_option.width
                color: managecontacts_option.pressed?(Constants.MENUITEM_PRESSED_COLOR):("transparent")
            }

            Label{
                anchors.top: parent.top
                anchors.topMargin: parent.a*options.pixelsize
                anchors.left: parent.left
                anchors.leftMargin: parent.a*options.pixelsize
                padding: 0
                font.pixelSize: parent.a*options.pixelsize
                font.bold: false
                text: "Manage contacts"
                opacity: parent.a
            }

            onClicked:{
                backbutton.action();
                options.close();
            }
        }

    }


    Rectangle{
        id: image_container
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width
        height: parent.width
        color: "white"
        smooth: true
        layer.enabled: true
        layer.effect: CustomElevation{
            source: image_container;
        }

        Image {
            id: profileimage
            width: parent.width
            height: parent.width
            source: main_frame.getCurrentImagePath()
            fillMode: Image.PreserveAspectCrop
            visible: true
            smooth: true
        }


        Button{
            id: changeavatar_button
            anchors.fill: parent
            background:Rectangle{color:"transparent"}

            onClicked: {
                changeavatar_button.action();
            }

            function action(){
                //profileimagefiledialog.open()
                if(block_buttons==false){
                    main_frame.openImagePicker();
                }
            }
        }
    }


    Label {
        id: nametext
        anchors.left: parent.left
        anchors.leftMargin: name_pixelsize/2
        anchors.bottom: image_container.bottom
        anchors.bottomMargin: name_pixelsize/2
        font.bold: true
        font.pixelSize: name_pixelsize
        text: main_frame.getCurrentUsername()
        color: "white"
        background: Rectangle{color:"transparent"}
    }

    Rectangle{
        id: status_container
        anchors.top: image_container.bottom
        anchors.topMargin: ((remaining_height-height)/2)
        anchors.left: parent.left
        anchors.right: parent.right
        height: statuscontainer_height
        color: "white"

        layer.enabled: true
        layer.effect: CustomElevation{
            source: status_container
        }

        Label{
            id: status_indicator
            anchors.top: parent.top
            anchors.topMargin: statusindicator_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: true
            font.pixelSize: statusindicator_pixelsize
            color: root.theme_color
            text: "Status"
        }

        Label{
            id: status_text
            anchors.top: parent.top
            anchors.topMargin: statustext_top_margin
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.pixelSize: statustext_pixelsize
            color: Constants.ProfilePage.TEXT_COLOR
            text: main_frame.getCurrentStatus();
            width: status_max_width
            wrapMode: TextArea.Wrap
        }

        Label{
            id: status_date
            anchors.top: status_text.bottom
            anchors.topMargin: statustext_pixelsize
            anchors.left: parent.left
            anchors.leftMargin: left_margin
            padding: 0
            font.bold: false
            font.italic: true
            font.pixelSize: statusdate_pixelsize
            color: Constants.ProfilePage.TEXT_COLOR
            opacity: 0.6
            text: "Last updated " + main_frame.getCurrentStatusDate();
        }

        Button{
            id: changestatus_button
            anchors.top: status_text.top
            anchors.topMargin: status_text.height/2-height/2
            anchors.right: parent.right
            anchors.rightMargin: left_margin
            height: changestatusbutton_size
            width: changestatusbutton_size

            background: Rectangle{color:"transparent"}

            OpacityMask{
                id: changestatus_icon
                anchors.fill: parent
                source: changestatus_source
                maskSource: changestatus_mask


                Rectangle{
                    id: changestatus_source
                    anchors.centerIn: parent
                    height: statustext_pixelsize
                    width: statustext_pixelsize
                    color: Constants.ProfilePage.TEXT_COLOR
                    visible: false
                }

                Image{
                    id: changestatus_mask
                    anchors.centerIn: parent
                    height: statustext_pixelsize
                    width: statustext_pixelsize
                    fillMode: Image.PreserveAspectFit
                    source: "icons/whitepencilicon.png"
                    visible: false
                }
            }

            onClicked: {
                newstatus_dialog.open();
            }

            function action(){
                if(block_buttons==false){
                    new_status.text = status_text.text;
                    text_box.open();
                }
            }
        }

        Rectangle{
            id: separator
            anchors.top: changestatus_button.top
            anchors.topMargin: changestatus_button.height/2 - height/2
            anchors.right: changestatus_button.left
            anchors.rightMargin: 3*left_margin/4
            width: 1
            height: 2*changestatus_button.height
            color: Constants.ProfilePage.TEXT_COLOR
        }
    }

    CustomInputDialog{
        id: newstatus_dialog
        anchors.fill: parent
        statusbar_color: main.decToColor(root.statusbar_color);
        icon_source: "icons/whitepencilicon.png"
        title_text: "Update status"
        initial_text: main_frame.getCurrentStatus();
        hint: "Enter new status"
        max_chars: 50
        min_chars: 1
        minchars_errstr: "Status cannot be void"
        counter_visible: true
        echo_mode: TextInput.Normal
        onDone:{
            main_frame.updateUserStatus(text);
            newstatus_dialog.close();
        }
    }

    Button{
        id: options_antifocus
        height: root.height
        width: root.width
        z: options.enabled?(options.z-1):(-1)
        enabled: options.enabled

        background:Rectangle{color:"transparent"}

        onClicked:{
            options.close();
        }

    }

    Rectangle{
        id: wait_box;
        anchors.fill: parent
        height: parent.height
        width: parent.width
        visible: false;
        color: Qt.rgba(1,1,1,0.85);


        AnimatedImage{
            source: "icons/loading.gif"
            width: 3*parent.width/8
            height: 3*parent.width/8
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2-width/2
            anchors.top: parent.top
            anchors.topMargin: parent.height/2-height/2
            fillMode: Image.PreserveAspectFit
        }

    }

    function goBack(){
        backbutton.action();
    }
}

















































