import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import Rolisteam 1.1

Item {
    id:root
    property alias realscale: imagebg.realscale
    focus: true
    property int page: 0
    property int maxPage:0
    onPageChanged: {
        page=page>maxPage ? maxPage : page<0 ? 0 : page
    }
    Keys.onLeftPressed: --page
    Keys.onRightPressed: ++page
    signal rollDiceCmd(string cmd, bool alias)
    signal showText(string text)
    MouseArea {
         anchors.fill:parent
         onClicked: root.focus = true
     }

    // ************
    // **  TODO ***
    // ** *
    // - hard set readonly in header section

    
    // ///
    // Id-Name
    // ------
    // id_124  : PoolUse1
    // id_126  : PoolUse2
    // id_125  : PoolUsed1
    // id_127  : PoolUsed2
    // id_128  : PoolUseSum
    // id_5054 : WholePageBtn
    // id_219  : EditOn
    // id_138  : InitAdd
    // id_137  : InitD6
    // id_140  : ModifBase
    // id_141  : ModifPerm
    // id_142  : ModifTmp
    // id_143  : ModifSum
    // id_144  : ThrManuel
    // id_151  : ThrTrg

    // ///
    // Global Vars
    // ------
    property int selectField:0
    property int selectValue:0
    property int selectTrgMod:0
    property int skillEdit:0
    property int reactEdit:0
    property int diceClicked:0
    property int monStunValue:0
    property int monPhysValue:0

    // //////////////////////
    // FUNCTIONS
    // /////////

    // ---
    // Whole page button
    function getWhlPgBtnVisible() {
         return ((id_219.value*1) > 0);
    }

    // ---
    // Selection functions
    function resetSelect() {
        selectField = 0
        selectValue = 0
        selectTrgMod = 0
    }

    // ---
    // Edit functions
    function editReset() {
        skillEdit = 0
        reactEdit = 0
    }
    function getEditBtnColor() {
        return "#ff000000";
    }
    function getEditBtnBgColor() {
        return "#ffe7dc8a";
    }
    function getEditBtnPrsColor() {
        return "#de2121";
    }
    function getEditBtnTxtColor() {
        return "#ff000000";
    }
    function getEditNameColor(editValue) {
        return "#ff000000";
    }
    function getEditNameBgcolor(editValue, nameValue) {
        switch ((id_219.value*1) > 0 && !getEditNameReadonly(editValue, nameValue)) {
            case true: return getEditBtnBgColor();
            case false: return "#00000000";
        }
    }
    function getEditNameVisible(editValue, nameValue) {
        return (getEditTblVisible(editValue) || editValue == nameValue);
    }
    function getEditNameReadonly(editValue, nameValue) {
        return (editValue != nameValue);
    }
    function getEditNameZ(editValue) {
        switch (editValue > 0) {
            case true: return editValue + 11
            case false: return 0;
        }
    }
    function getEditTblVisible(editValue) {
        return (editValue == 0);
    }


    // ---
    // Pools and new turns Functions
    function poolApplyUsed() { // New turn
        // /* PoolUsed1 = PoolUsed1 + PoolUse1 */
        id_125.value = id_125.value*1 + id_124.value*1;
        id_124.value = 0;
        // /* PoolUsed2 = PoolUsed2 + PoolUse2 */
        id_127.value = id_127.value*1 + id_126.value*1;
        id_126.value = 0;
    }
    function poolReset() {
        id_124.value = 0;
        id_126.value = 0;
        id_125.value = 0;
        id_127.value = 0;
    }
    function modifReset() {
       id_142.value = 0;  // ModifTmp
    }
    function newThrow() {
       poolApplyUsed()
       modifReset()
    }
    function newTurn() {
       poolReset()
       modifReset()
    }

    // --
    // Throwing and Dice Functions
    function getThrD6() {
        // selectValue + PoolUseSum
        return selectValue + id_128.value*1;
    }
    function getThrTrg() {
        if (!Number.isInteger(id_151.value*1)) return 0;
        return id_151.value*1;
    }
    function getThrTrgAjusted() {
        if (getThrTrg() == 0) return 0;
        // Target is always minimum 2
        if (getThrTrg() + id_143.value*1 < 2) return 2;
        return getThrTrg() + id_143.value*1;
    }
    function getThrOpenEnabled() {
        if (getThrD6() <= 0) return false;
        return true;
    }
    function getThrTrgEnabled() {
        if (getThrD6() <= 0) return false;
        if (getThrTrgAjusted() < 2) return false;
        return true;
    }
    function getThrInitEnabled() {
        // For future implementation
        // return (id_138.value*1 <= 0);
        return true;
    }

    // --
    // Monitors Functions
    function getMonColor(monValue, boxNb) {
        if (boxNb > monValue || monValue == 0) return "#00000000";
        switch (true) {
            case (monValue < 3): return "#069a2e";  // Green
            case (monValue < 6): return "#e6e905";  // Yellow
            case (monValue < 10): return "#ea7500"; // Orange
            case (monValue == 10): return "#f10d0c";   // Red
        }
    }
    function getMonStunMalus() {
        if (monStunValue < 1) {
            return 0;
        } else if (monStunValue < 3) {
            return 1;
        } else if (monStunValue < 6) {
            return 2;
        } else {
            return 3;
        }
    }
    function getMonPhysMalus() {
        if (monPhysValue < 1) {
            return 0;
        } else if (monPhysValue < 3) {
            return 1;
        } else if (monPhysValue < 6) {
            return 2;
        } else {
            return 3;
        }
    }
    function getMonMalus() {
        var i;
        i = getMonStunMalus();
        i = i + getMonPhysMalus();
        return i;
    }
    // END
    // ///

    // Background image
    Image {
        id:imagebg
        objectName:"imagebg"
        property real iratio :0.734579
        property real iratiobis :1.36132
        property real realscale: width/393
        width:(parent.width>parent.height*iratio)?iratio*parent.height:parent.width
        height:(parent.width>parent.height*iratio)?parent.height:iratiobis*parent.width
        source: "image://rcs/513083d2-654d-45fc-875c-db37b0c6fa2a_background_%1.jpg".arg(root.page)

    // ///
    // CONTENT BEGIN
    // /

    DiceButton {//WholePageBtn
        id: _id_5054
        command: id_5054.value
        text: id_5054.label
        pressedColor: "#00000000"
        color: "#00000000"
        backgroundColor: "#00000000"
        textColor: "#00000000"
        visible: root.page == 0 && getWhlPgBtnVisible()? true : false
        readOnly: id_5054.readOnly
        tooltip:""
        x:0*root.realscale
        y:0*root.realscale
        z: id_219.value*1 + 10  // EditOn
        width:393*root.realscale
        height:535*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onClicked: editReset()
    }

    TextInputField {//EditOn
        id: _id_219
        text: skillEdit + reactEdit
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: false
        readOnly: id_219.readOnly
        tooltip:""
        x:0*root.realscale
        y:0*root.realscale
        width:6*root.realscale
        height:15*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_219.value = text
        }
    }

    TextInputField {//CharName
        id: _id_1
        text: id_1.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_1.readOnly
        tooltip:""
        x:8*root.realscale
        y:6*root.realscale
        width:199*root.realscale
        height:39.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "TeX Gyre Bonum"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 16
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_1.value = text
        }
    }
    ImageField {//CharAvatar
        id: _id_2
        source: id_2.value
        color: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_2.readOnly
        x:211.5*root.realscale
        y:6*root.realscale
        width:70*root.realscale
        height:71*root.realscale
    }


    // MONITORS
    Table{//MonStunTbl
        id: _id_3list
        field: id_3
        x:25*root.realscale
        y:49*root.realscale
        width:180*root.realscale
        height:19*root.realscale
        visible: root.page == 0? true : false
        maxRow:1
        model: id_3.model
        delegate: RowLayout {
            height: _id_3list.height/_id_3list.maxRow
            width:  _id_3list.width
            spacing:0
            CheckBoxField {//MonStunBox1
                field: MonStunBox1
                text: monStunValue >= 1? 1 : 0
                color: getMonColor(monStunValue, 1)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox1.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 1) {
                        monStunValue = 0
                    } else {
                        monStunValue = 1
                    }
                }
            }
            CheckBoxField {//MonStunBox2
                field: MonStunBox2
                text: monStunValue >= 2? 1 : 0
                color: getMonColor(monStunValue, 2)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox2.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 2) {
                        monStunValue = 1
                    } else {
                        monStunValue = 2
                    }
                }
            }
            CheckBoxField {//MonStunBox3
                field: MonStunBox3
                text: monStunValue >= 3? 1 : 0
                color: getMonColor(monStunValue, 3)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox3.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 3) {
                        monStunValue = 2
                    } else {
                        monStunValue = 3
                    }
                }
            }
            CheckBoxField {//MonStunBox4
                field: MonStunBox4
                text: monStunValue >= 4? 1 : 0
                color: getMonColor(monStunValue, 4)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox4.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 4) {
                        monStunValue = 3
                    } else {
                        monStunValue = 4
                    }
                }
            }
            CheckBoxField {//MonStunBox5
                field: MonStunBox5
                text: monStunValue >= 5? 1 : 0
                color: getMonColor(monStunValue, 5)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox5.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 5) {
                        monStunValue = 4
                    } else {
                        monStunValue = 5
                    }
                }
            }
            CheckBoxField {//MonStunBox6
                field: MonStunBox6
                text: monStunValue >= 6? 1 : 0
                color: getMonColor(monStunValue, 6)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox6.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 6) {
                        monStunValue = 5
                    } else {
                        monStunValue = 6
                    }
                }
            }
            CheckBoxField {//MonStunBox7
                field: MonStunBox7
                text: monStunValue >= 7? 1 : 0
                color: getMonColor(monStunValue, 7)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox7.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 7) {
                        monStunValue = 6
                    } else {
                        monStunValue = 7
                    }
                }
            }
            CheckBoxField {//MonStunBox8
                field: MonStunBox8
                text: monStunValue >= 8? 1 : 0
                color: getMonColor(monStunValue, 8)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox8.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 8) {
                        monStunValue = 7
                    } else {
                        monStunValue = 8
                    }
                }
            }
            CheckBoxField {//MonStunBox9
                field: MonStunBox9
                text: monStunValue >= 9? 1 : 0
                color: getMonColor(monStunValue, 9)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox9.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 9) {
                        monStunValue = 8
                    } else {
                        monStunValue = 9
                    }
                }
            }
            CheckBoxField {//MonStunBox10
                field: MonStunBox10
                text: monStunValue >= 10? 1 : 0
                color: getMonColor(monStunValue, 10)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonStunBox10.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monStunValue == 10) {
                        monStunValue = 9
                    } else {
                        monStunValue = 10
                    }
                }
            }
        }
    }

    Table{//MonPhysTbl
        id: _id_4list
        field: id_4
        x:25*root.realscale
        y:76*root.realscale
        width:180*root.realscale
        height:19*root.realscale
        visible: root.page == 0? true : false
        maxRow:1
        model: id_4.model
        delegate: RowLayout {
            height: _id_4list.height/_id_4list.maxRow
            width:  _id_4list.width
            spacing:0
            CheckBoxField {//MonPhysBox1
                field: MonPhysBox1
                text: monPhysValue >= 1? 1 : 0
                color: getMonColor(monPhysValue, 1)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox1.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 1) {
                        monPhysValue = 0
                    } else {
                        monPhysValue = 1
                    }
                }
            }
            CheckBoxField {//MonPhysBox2
                field: MonPhysBox2
                text: monPhysValue >= 2? 1 : 0
                color: getMonColor(monPhysValue, 2)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox2.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 2) {
                        monPhysValue = 1
                    } else {
                        monPhysValue = 2
                    }
                }
            }
            CheckBoxField {//MonPhysBox3
                field: MonPhysBox3
                text: monPhysValue >= 3? 1 : 0
                color: getMonColor(monPhysValue, 3)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox3.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 3) {
                        monPhysValue = 2
                    } else {
                        monPhysValue = 3
                    }
                }
            }
            CheckBoxField {//MonPhysBox4
                field: MonPhysBox4
                text: monPhysValue >= 4? 1 : 0
                color: getMonColor(monPhysValue, 4)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox4.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 4) {
                        monPhysValue = 3
                    } else {
                        monPhysValue = 4
                    }
                }
            }
            CheckBoxField {//MonPhysBox5
                field: MonPhysBox5
                text: monPhysValue >= 5? 1 : 0
                color: getMonColor(monPhysValue, 5)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox5.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 5) {
                        monPhysValue = 4
                    } else {
                        monPhysValue = 5
                    }
                }
            }
            CheckBoxField {//MonPhysBox6
                field: MonPhysBox6
                text: monPhysValue >= 6? 1 : 0
                color: getMonColor(monPhysValue, 6)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox6.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 6) {
                        monPhysValue = 5
                    } else {
                        monPhysValue = 6
                    }
                }
            }
            CheckBoxField {//MonPhysBox7
                field: MonPhysBox7
                text: monPhysValue >= 7? 1 : 0
                color: getMonColor(monPhysValue, 7)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox7.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 7) {
                        monPhysValue = 6
                    } else {
                        monPhysValue = 7
                    }
                }
            }
            CheckBoxField {//MonPhysBox8
                field: MonPhysBox8
                text: monPhysValue >= 8? 1 : 0
                color: getMonColor(monPhysValue, 8)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox8.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 8) {
                        monPhysValue = 7
                    } else {
                        monPhysValue = 8
                    }
                }
            }
            CheckBoxField {//MonPhysBox9
                field: MonPhysBox9
                text: monPhysValue >= 9? 1 : 0
                color: getMonColor(monPhysValue, 9)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox9.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 9) {
                        monPhysValue = 8
                    } else {
                        monPhysValue = 9
                    }
                }
            }
            CheckBoxField {//MonPhysBox10
                field: MonPhysBox10
                text: monPhysValue >= 10? 1 : 0
                color: getMonColor(monPhysValue, 10)
                borderColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: MonPhysBox10.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 18*root.realscale
                onClicked: {
                    if (monPhysValue == 10) {
                        monPhysValue = 9
                    } else {
                        monPhysValue = 10
                    }
                }
            }
        }
    }

    TextInputField {//MonDmgOvrfl
        id: _id_5
        text: id_5.value
        color: id_5.value == 0? "#ff000000" : "#f10d0c"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_5.readOnly
        tooltip:""
        x:239*root.realscale
        y:83.5*root.realscale
        width:27*root.realscale
        height:26*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_5.value = text
        }
    }

    TextInputField {//MonInitMalus
        id: _id_2698
        text: "-" + getMonMalus()
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_2698.readOnly
        tooltip:""
        x:80*root.realscale
        y:98*root.realscale
        width:19.5*root.realscale
        height:12*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 7
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_2698.value = text
        }
    }
    TextInputField {//MonTrgMalus
        id: _id_2699
        text: "+" + getMonMalus()
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_2699.readOnly
        tooltip:""
        x:185*root.realscale
        y:98*root.realscale
        width:19.5*root.realscale
        height:12*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 7
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_2699.value = text
        }
    }

    // ///
    // ATTRIBUTES
    Table{//AttTbl
        id: _id_33list
        field: id_33
        x:8*root.realscale
        y:157.5*root.realscale
        width:172*root.realscale
        height:185.5*root.realscale
        visible: root.page == 0? true : false
        maxRow:6
        model: id_33.model
        delegate: RowLayout {
            height: _id_33list.height/_id_33list.maxRow
            width:  _id_33list.width
            spacing:0
            property int rowindex: index + 1
            DiceButton {//AttBtn
                command: AttBtn.value
                text: ""
                pressedColor: "#de2121"
                color: "#00000000"
                backgroundColor: "#00000000"
                textColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: AttBtn.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 75.25*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onClicked: {
                    selectField = rowindex
                    selectValue = AttNow.value*1
                    selectTrgMod = 0
                }
            }
            TextInputField {//AttNat
                text: AttNat.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: AttNat.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 30.75*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    AttNat.value = text
                }
            }
            TextInputField {//AttMod
                text: AttMod.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: AttMod.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 33.25*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    AttMod.value = text
                }
            }
            TextInputField {//AttNow
                text: AttNow.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: AttNow.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.75*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    AttNow.value = text;
                    resetSelect();
                }
            }
        }
    }

    ImageField {//AttSel1
        id: _id_8
        source: id_8.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 1? true : false
        readOnly: id_8.readOnly
        x:8*root.realscale
        y:157.5*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//AttSel2
        id: _id_9
        source: id_9.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 2? true : false
        readOnly: id_9.readOnly
        x:8*root.realscale
        y:188*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//AttSel3
        id: _id_10
        source: id_10.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 3? true : false
        readOnly: id_10.readOnly
        x:8*root.realscale
        y:219*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//AttSel4
        id: _id_11
        source: id_11.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 4? true : false
        readOnly: id_11.readOnly
        x:8*root.realscale
        y:250*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//AttSel5
        id: _id_12
        source: id_12.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 5? true : false
        readOnly: id_12.readOnly
        x:8*root.realscale
        y:281*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//AttSel6
        id: _id_13
        source: id_13.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 6? true : false
        readOnly: id_13.readOnly
        x:8*root.realscale
        y:312*root.realscale
        width:75.5*root.realscale
        height:30*root.realscale
    }

    // ///
    // SKILLS
    ImageField {//SkillSel1
        id: _id_214
        source: id_214.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 11? true : false
        readOnly: id_214.readOnly
        x:194*root.realscale
        y:157.5*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//SkillSel2
        id: _id_21
        source: id_21.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 12? true : false
        readOnly: id_21.readOnly
        x:194*root.realscale
        y:188*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//SkillSel3
        id: _id_22
        source: id_22.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 13? true : false
        readOnly: id_22.readOnly
        x:194*root.realscale
        y:219*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//SkillSel4
        id: _id_23
        source: id_23.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 14? true : false
        readOnly: id_23.readOnly
        x:194*root.realscale
        y:250*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//SkillSel5
        id: _id_24
        source: id_24.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 15? true : false
        readOnly: id_24.readOnly
        x:194*root.realscale
        y:281*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//SkillSel6
        id: _id_25
        source: id_25.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 16? true : false
        readOnly: id_25.readOnly
        x:194*root.realscale
        y:312*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }

    TextInputField {//SkillName1
        id: _id_14
        text: id_14.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 1)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 1)? true : false
        readOnly: getEditNameReadonly(skillEdit, 1)
        tooltip:""
        x:194*root.realscale
        y:157.5*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_14.value = text
        }
        onEditingFinished: {
            skillEdit = 0    
        }
    }
    TextInputField {//SkillName2
        id: _id_15
        text: id_15.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 2)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 2)? true : false
        readOnly: getEditNameReadonly(skillEdit, 2)
        tooltip:""
        x:194*root.realscale
        y:188*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_15.value = text
        }
        onEditingFinished: {
            skillEdit = 0
        }
    }
    TextInputField {//SkillName3
        id: _id_16
        text: id_16.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 3)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 3)? true : false
        readOnly: getEditNameReadonly(skillEdit, 3)
        tooltip:""
        x:194*root.realscale
        y:219*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_16.value = text
        }
        onEditingFinished: {
            skillEdit = 0    
        }
    }
    TextInputField {//SkillName4
        id: _id_17
        text: id_17.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 4)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 4)? true : false
        readOnly: getEditNameReadonly(skillEdit, 4)
        tooltip:""
        x:194*root.realscale
        y:250*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_17.value = text
        }
        onEditingFinished: {
            skillEdit = 0    
        }
    }
    TextInputField {//SkillName5
        id: _id_18
        text: id_18.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 5)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 5)? true : false
        readOnly: getEditNameReadonly(skillEdit, 5)
        tooltip:""
        x:194*root.realscale
        y:281*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_18.value = text
        }
        onEditingFinished: {
            skillEdit = 0
        }
    }
    TextInputField {//SkillName6
        id: _id_19
        text: id_19.value
        color: getEditNameColor(skillEdit)
        backgroundColor: getEditNameBgcolor(skillEdit, 6)
        visible: root.page == 0 && getEditNameVisible(skillEdit, 6)? true : false
        readOnly: getEditNameReadonly(skillEdit, 6)
        tooltip:""
        x:194*root.realscale
        y:312*root.realscale
        z: getEditNameZ(skillEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_19.value = text
        }
        onEditingFinished: {
            skillEdit = 0
        }
    }

    Table{//SkillTbl
        id: _id_45list
        field: id_45
        x:184*root.realscale
        y:157.5*root.realscale
        width:205*root.realscale
        height:185*root.realscale
        visible: root.page == 0 && getEditTblVisible(skillEdit)? true : false
        maxRow:6
        model: id_45.model
        delegate: RowLayout {
            height: _id_45list.height/_id_45list.maxRow
            width:  _id_45list.width
            spacing:0
            property int rowindex: index + 1
            DiceButton {//SkillEdit
                command: SkillEdit.value
                text: "@"
                pressedColor: getEditBtnPrsColor()
                color: getEditBtnColor()
                backgroundColor: getEditBtnBgColor()
                textColor: getEditBtnTxtColor()
                visible: root.page == 0? true : false
                readOnly: SkillEdit.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 9.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Webdings"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 9
                font.overline: false
                font.strikeout: false
                onClicked: {
                    resetSelect();
                    skillEdit = rowindex
                }
            }
            DiceButton {//SkillBtn
                command: SkillBtn.value
                text: ""
                pressedColor: "#de2121"
                color: "#00000000"
                backgroundColor: "#00000000"
                textColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: SkillBtn.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 65.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onClicked: {
                    selectField = rowindex + 10
                    selectValue = SkillNow.value*1
                    selectTrgMod = SkillTrgMod.value*1
                }
            }
            TextInputField {//SkillAtt
                text: SkillAtt.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: SkillAtt.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    SkillAtt.value = text
                }
            }
            TextInputField {//SkillRat
                text: SkillRat.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: SkillRat.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    SkillRat.value = text
                }
            }
            TextInputField {//SkillNow
                text: SkillAtt.value*1 + SkillRat.value*1
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: SkillNow.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    SkillNow.value = text
                    resetSelect();
                }
            }
            TextInputField {//SkillTrgMod
                text: SkillTrgMod.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: SkillTrgMod.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    SkillTrgMod.value = text
                    resetSelect();
                }
            }
        }
    }

    // ///
    // REACTION
    ImageField {//ReactSel1
        id: _id_118
        source: id_118.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 21? true : false
        readOnly: id_118.readOnly
        x:17.5*root.realscale
        y:389*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }
    ImageField {//ReactSel2
        id: _id_119
        source: id_119.value
        color: "#00000000"
        visible: root.page == 0 && selectField == 22? true : false
        readOnly: id_119.readOnly
        x:17.5*root.realscale
        y:420.5*root.realscale
        width:65.5*root.realscale
        height:30*root.realscale
    }

    TextInputField {//ReactName1
        id: _id_116
        text: id_116.value
        color: getEditNameColor(reactEdit)
        backgroundColor: getEditNameBgcolor(reactEdit, 1)
        visible: getEditNameVisible(reactEdit, 1) && root.page == 0? true : false
        readOnly: getEditNameReadonly(reactEdit, 1)
        tooltip:""
        x:17.5*root.realscale
        y:389*root.realscale
        z: getEditNameZ(reactEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_116.value = text
        }
        onEditingFinished: {
            reactEdit = 0
        }
    }
    TextInputField {//ReactName2
        id: _id_117
        text: id_117.value
        color: getEditNameColor(reactEdit)
        backgroundColor: getEditNameBgcolor(reactEdit, 2)
        visible: getEditNameVisible(reactEdit, 2) && root.page == 0? true : false
        readOnly: getEditNameReadonly(reactEdit, 2)
        tooltip:""
        x:17.5*root.realscale
        y:420.5*root.realscale
        z: getEditNameZ(reactEdit)
        width:65.5*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_117.value = text
        }
        onEditingFinished: {
            reactEdit = 0
        }
    }

    Table{//ReactTbl
        id: _id_26list
        field: id_26
        x:8*root.realscale
        y:389*root.realscale
        width:171.5*root.realscale
        height:63.5*root.realscale
        visible: getEditTblVisible(reactEdit) && root.page == 0? true : false
        maxRow:2
        model: id_26.model
        delegate: RowLayout {
            height: _id_26list.height/_id_26list.maxRow
            width:  _id_26list.width
            spacing:0
            property int rowindex: index + 1
            DiceButton {//ReactEdit
                command: ReactEdit.value
                text: "@"
                pressedColor: getEditBtnPrsColor()
                color: getEditBtnColor()
                backgroundColor: getEditBtnBgColor()
                textColor: getEditBtnTxtColor()
                visible: root.page == 0? true : false
                readOnly: ReactEdit.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 9.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Webdings"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 9
                font.overline: false
                font.strikeout: false
                onClicked: {
                    resetSelect();
                    reactEdit = rowindex
                }
            }
            DiceButton {//ReactBtn
                command: ReactBtn.value
                text: ""
                pressedColor: "#de2121"
                color: "#00000000"
                backgroundColor: "#00000000"
                textColor: "#ff000000"
                visible: root.page == 0? true : false
                readOnly: ReactBtn.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 65.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onClicked: {
                    selectField = rowindex + 20
                    selectValue = ReactNow.value
                }
            }
            TextInputField {//ReactNat
                text: ReactNat.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: ReactNat.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    ReactNat.value = text
                }
            }
            TextInputField {//ReactMod
                text: ReactMod.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: ReactMod.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    ReactMod.value = text
                }
            }
            TextInputField {//ReactNow
                text: ReactNow.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: ReactNow.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    ReactNow.value = text
                    resetSelect();
                }
            }
        }
    }

    // ///
    // POOLS
    Table{//PoolTbl
        id: _id_122list
        field: id_122
        x:183*root.realscale
        y:389*root.realscale
        width:206*root.realscale
        height:63.5*root.realscale
        visible: root.page == 0? true : false
        maxRow:2
        model: id_122.model
        delegate: RowLayout {
            height: _id_122list.height/_id_122list.maxRow
            width:  _id_122list.width
            spacing:0
            property int rowindex: index + 1
            function getUse(rowID) {
                switch (rowID) {
                    case 1: return id_124.value;  // PoolUse1
                    case 2: return id_126.value;  // PoolUse2
                 }
            }

            function setUse(rowID, newValue) {
                if (!checkValidityUseValue(rowID, newValue)) return;
                switch (rowID) {
                    case 1: id_124.value = newValue;  // PoolUse1
                    break;
                    case 2: id_126.value = newValue;  // PoolUse2
                    break;
                 }
            }

            function checkValidityUseValue(rowID, myValue) {
                var tmpValue = myValue*1
                if (!Number.isInteger(tmpValue)) return false;
                if (tmpValue < 0) return false;
                if (tmpValue > (PoolSum.value*1 - PoolUsed.value*1)) return false;
                return true;
            }

            function getUsed(rowID) {
                switch (rowID) {
                   case 1: return id_125.value;  // PoolUsed1
                   case 2: return id_127.value;  // PoolUsed2
                }
            }
            function setUsed(rowID, newValue) {
                switch (rowID) {
                    case 1: id_125.value = newValue;  // PoolUsed1
                    break;
                    case 2: id_127.value = newValue;  // PoolUsed2
                    break;
                 }
            }
            function getUseColor(rowID, displayedValue) {
                if (checkValidityUseValue(rowID, displayedValue)) {
                    return "#ff000000";
                } else {
                    return "#ffc21d8e";
                }
            }
            function getUseDefaultValue(myValue) {
                var tmpValue;
                if (!Number.isInteger(myValue)) tmpValue = myValue.replace(/\D/g,'');
                if (!Number.isInteger(myValue)) return 0;
                tmpValue = tmpValue*1;
                if (tmpValue < 0) return tmpValue*-1;
                return (PoolSum.value*1 - PoolUsed.value*1);
            }

            TextInputField {//PoolName
                text: PoolName.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: PoolName.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 76*root.realscale
                hAlign: TextInput.AlignLeft
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 9
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolName.value = text
                }
            }

            TextInputField {//PoolQty
                text: PoolQty.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: PoolQty.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolQty.value = text
                }
            }

            TextInputField {//PoolAvlb
                text: PoolSum.value*1 - getUsed(rowindex) - getUse(rowindex)
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: PoolAvlb.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolAvlb.value = text
                }
            }

            TextInputField {//PoolMod
                text: PoolMod.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: PoolMod.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolMod.value = text
                }
            }

            TextInputField {//PoolUse
                text: PoolUse.value  // getUse(rowindex)
                color: getUseColor(rowindex, PoolUse.value)  // "#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: PoolUse.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 32.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolUse.value = text
                    setUse(rowindex, text)
                }
                onEditingFinished: if (!checkValidityUseValue(rowindex, text)) PoolUse.value = getUseDefaultValue(rowindex, text)
            }

            TextInputField {//PoolUsed
                text: getUsed(rowindex)
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: false
                readOnly: PoolUsed.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 0*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
            }

            TextInputField {//PoolSum
                text: PoolQty.value*1 + PoolMod.value*1
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: false
                readOnly: PoolSum.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 0*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    PoolSum.value = text
                }
            }
        }
    }

    TextInputField {//PoolUse1
        id: _id_124
        text: id_124.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: false
        readOnly: id_124.readOnly
        tooltip:""
        x:388*root.realscale
        y:389.758*root.realscale
        width:3*root.realscale
        height:15*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_124.value = text
        }
    }
    TextInputField {//PoolUsed1
        id: _id_125
        text: id_125.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: false
        readOnly: id_125.readOnly
        tooltip:""
        x:388*root.realscale
        y:404*root.realscale
        width:3*root.realscale
        height:15*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_125.value = text
        }
    }
    TextInputField {//PoolUse2
        id: _id_126
        text: id_126.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: false
        readOnly: id_126.readOnly
        tooltip:""
        x:388*root.realscale
        y:419*root.realscale
        width:3*root.realscale
        height:15*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_126.value = text
        }
    }
    TextInputField {//PoolUsed2
        id: _id_127
        text: id_127.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: false
        readOnly: id_127.readOnly
        tooltip:""
        x:388*root.realscale
        y:434*root.realscale
        width:3*root.realscale
        height:15*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_127.value = text
        }
    }
    TextInputField {//PoolUseSum
        id: _id_128
        text: id_124.value*1 + id_125.value*1
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_128.readOnly
        tooltip:""
        x:355.5*root.realscale
        y:347*root.realscale
        width:31*root.realscale
        height:24*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_128.value = text
        }
    }

    // For debug purposes
    DiceButton {//PoolBtnReset
        id: _id_434
        command: id_434.value
        text: "Reset"
        pressedColor: "#ff000000"
        color: "#ffc21d8e"
        backgroundColor: "#ffc21d8e"
        textColor: "#ff000000"
        visible: false  // Keep hidden unless needed for debug
        readOnly: id_434.readOnly
        tooltip:""
        x:240.196*root.realscale
        y:356.863*root.realscale
        width:41.1765*root.realscale
        height:12.7451*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onClicked: {
            poolReset()
            resetSelect()
            editReset()
        }
    }

    Table{//InitTbl
        id: _id_136list
        field: id_136
        x:8*root.realscale
        y:500.5*root.realscale
        width:138*root.realscale
        height:30*root.realscale
        visible: root.page == 0? true : false
        maxRow:1
        model: id_136.model
        delegate: RowLayout {
            height: _id_136list.height/_id_136list.maxRow
            width:  _id_136list.width
            spacing:0
            function updateInitCmd() {
                id_138.value = InitReact.value*1 - getMonMalus()
                id_137.value = InitAddD6.value*1 + 1
            }
            TextInputField {//InitName
                text: InitName.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: InitName.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 75*root.realscale
                hAlign: TextInput.AlignLeft
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 9
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    InitName.value = text
                }
            }
            TextInputField {//InitReact
                text: InitReact.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: InitReact.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 31.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    InitReact.value = text
                    updateInitCmd()
                }
            }
            TextInputField {//InitAddD6
                text: InitAddD6.value
                color:"#ff000000"
                backgroundColor: "#00000000"
                visible: root.page == 0? true : false
                readOnly: InitAddD6.readOnly
                tooltip:""
                Layout.fillHeight: true
                Layout.preferredWidth: 31.5*root.realscale
                hAlign: TextInput.AlignHCenter
                vAlign: TextInput.AlignVCenter
                font.family:  "Sans Serif"
                font.bold:    false
                font.italic:  false
                font.underline: false
                font.pointSize: 13
                font.overline: false
                font.strikeout: false
                onTextChanged: {
                    InitAddD6.value = text
                    updateInitCmd()
                }
            }
        }
    }

    TextInputField {//InitD6
        id: _id_137
        text: id_137.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_137.readOnly
        tooltip:""
        x:74*root.realscale
        y:462.5*root.realscale
        width:14*root.realscale
        height:16.5*root.realscale
        hAlign: TextInput.AlignRight
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_137.value = text
        }
    }

    TextInputField {//InitAdd
        id: _id_138
        text: id_138.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_138.readOnly
        tooltip:""
        x:121*root.realscale
        y:462.5*root.realscale
        width:19*root.realscale
        height:16.5*root.realscale
        hAlign: TextInput.AlignLeft
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_138.value = text
        }
    }

    ImageField {//InitDice
        id: _id_373
        source: id_373.value
        color: "#00000000"
        visible: diceClicked != 1 && getThrInitEnabled() && root.page == 0? true : false
        readOnly: id_373.readOnly
        x:52.5*root.realscale
        y:460*root.realscale
        width:19.5*root.realscale
        height:19.5*root.realscale
    }
    ImageField {//InitDicePressed
        id: _id_374
        source: id_374.value
        color: "#00000000"
        visible: diceClicked == 1 && root.page == 0? true : false
        readOnly: id_374.readOnly
        x:52.5*root.realscale
        y:460*root.realscale
        width:19.5*root.realscale
        height:16.5*root.realscale
    }
    ImageField {//InitDiceDisabled
        id: _id_375
        source: id_375.value
        color: "#00000000"
        visible: !getThrInitEnabled() && root.page == 0? true : false
        readOnly: id_375.readOnly
        x:52.5*root.realscale
        y:460*root.realscale
        width:19.5*root.realscale
        height:20.5*root.realscale
    }

    DiceButton {//InitRoll
        id: _id_139
        command: id_139.value
        text: ""
        pressedColor: "#ffde2121"
        color: "#00000000"
        backgroundColor: "#00000000"
        textColor: "#ff000000"
        visible: id_138.value*1 > 0 && root.page == 0? true : false
        readOnly: id_139.readOnly
        tooltip:"Roll inititive !!!"
        x:50.5*root.realscale
        y:458*root.realscale
        width:95.5*root.realscale
        height:24*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onPressed: diceClicked = 1
        onReleased: diceClicked = 0
        onClicked: {
            rollDiceCmd(id_137.value +
                        "d6+" +
                        id_138.value,true);
            newTurn();
        }
    }

    // ///
    // MODIFICATORS
    TextInputField {//ModifBase
        id: _id_140
        text: getMonMalus() + selectTrgMod
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_140.readOnly
        tooltip:""
        x:149.5*root.realscale
        y:500.5*root.realscale
        width:33*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_140.value = text
        }
    }

    TextInputField {//ModifPerm
        id: _id_141
        text: id_141.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_141.readOnly
        tooltip:""
        x:182.5*root.realscale
        y:500.5*root.realscale
        width:33*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_141.value = text
        }
    }
    TextInputField {//ModifTmp
        id: _id_142
        text: id_142.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_142.readOnly
        tooltip:""
        x:215*root.realscale
        y:500.5*root.realscale
        width:33*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_142.value = text
        }
    }
    TextInputField {//ModifSum
        id: _id_143
        text: id_140.value*1 + id_141.value*1 + id_142.value*1
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_143.readOnly
        tooltip:""
        x:215*root.realscale
        y:460*root.realscale
        width:30*root.realscale
        height:20.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_143.value = text
        }
    }

    // ///
    // THROW THE DICE
    TextInputField {//ThrManual
        id: _id_144
        text: id_144.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_144.readOnly
        tooltip:""
        x:254*root.realscale
        y:500*root.realscale
        z:2
        width:30*root.realscale
        height:30*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_144.value = text
            resetSelect()
        }
    }

    DiceButton {//ThrManualBtn
        id: _id_145
        command: id_145.value
        text: ""
        pressedColor: "#ffde2121"
        color: "#00000000"
        backgroundColor: "#00000000"
        textColor: "#ff000000"
        visible: root.page == 0? true : false
        readOnly: id_145.readOnly
        tooltip:"Set custom number of D6"
        x:253.5*root.realscale
        y:460*root.realscale
        z:1
        width:32*root.realscale
        height:39.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onClicked: {
            selectField = 31
            selectValue = id_144.value*1  // ThrManual
            selectTrgMod = 0
        }
    }

    ImageField {//ThrManualSel
        id: _id_146
        source: id_146.value
        color: "#00000000"
        visible: selectField == 31 && root.page == 0? true : false
        readOnly: id_146.readOnly
        x:253.5*root.realscale
        y:460*root.realscale
        width:32*root.realscale
        height:39.5*root.realscale
    }

    DiceButton {//ThrOpenRoll
        id: _id_149
        command: id_149.value
        text: ""
        pressedColor: "#ffde2121"
        color: "#00000000"
        backgroundColor: "#00000000"
        textColor: "#ff000000"
        visible: getThrOpenEnabled() && root.page == 0? true : false
        readOnly: id_149.readOnly
        tooltip:"Roll for highest number !!!"
        x:300*root.realscale
        y:500.5*root.realscale
        width:29*root.realscale
        height:28.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onPressed:diceClicked = 3
        onReleased:diceClicked = 0
        onClicked: {
            // # D6 : selectValue + PoolUseSum
            // Result: highest number - ModifSum
            rollDiceCmd((selectValue*1 + id_128.value*1) +
                        "d6K1+" +
                         id_143.value*-1,true);
            newThrow();
        }
    }

    DiceButton {//ThrTrgRoll
        id: _id_150
        command: id_150.value
        text: ""
        pressedColor: "#ffde2121"
        color: "#00000000"
        backgroundColor: "#00000000"
        textColor: "#ff000000"
        visible: getThrTrgEnabled() && root.page == 0? true : false
        readOnly: id_150.readOnly
        tooltip:"Roll against a target number !!!"
        x:343.5*root.realscale
        y:501*root.realscale
        width:28.5*root.realscale
        height:29.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 9
        font.overline: false
        font.strikeout: false
        onPressed: diceClicked = 3
        onReleased: diceClicked = 0
        onClicked: {
            rollDiceCmd(getThrD6 + "d6e6c[>" + getThrTrgAjusted + "]",true);
            newThrow();
        }
    }

    TextInputField {//ThrTrg
        id: _id_151
        text: id_151.value
        color:"#ff000000"
        backgroundColor: "#ffffffff"
        visible: root.page == 0? true : false
        readOnly: id_151.readOnly
        tooltip:""
        x:341.5*root.realscale
        y:469*root.realscale
        width:30*root.realscale
        height:25.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_151.value = text
        }
    }

    ImageField {//ThrTrgDice
        id: _id_148
        source: id_148.value
        color: "#00000000"
        visible: diceClicked != 3 && getThrTrgEnabled() && id_151.value*1 > 0 && root.page == 0? true : false
        readOnly: id_148.readOnly
        x:343.5*root.realscale
        y:501*root.realscale
        width:28*root.realscale
        height:29*root.realscale
    }
    ImageField {//ThrTrgDicePressed
        id: _id_370
        source: id_370.value
        color: "#00000000"
        visible: diceClicked == 3 && root.page == 0? true : false
        readOnly: id_370.readOnly
        x:343.5*root.realscale
        y:501*root.realscale
        width:28*root.realscale
        height:29*root.realscale
    }
    ImageField {//ThrTrgDiceDisabled
        id: _id_372
        source: id_372.value
        color: "#00000000"
        visible: !getThrTrgEnabled() && root.page == 0? true : false
        readOnly: id_372.readOnly
        x:343.5*root.realscale
        y:501*root.realscale
        width:28*root.realscale
        height:29*root.realscale
    }

    ImageField {//ThrOpenDice
        id: _id_147
        source: id_147.value
        color: "#00000000"
        visible: diceClicked != 2 && getThrOpenEnabled() && root.page == 0? true : false
        readOnly: id_147.readOnly
        x:300*root.realscale
        y:500.5*root.realscale
        width:27.5*root.realscale
        height:29*root.realscale
    }
    ImageField {//ThrOpenDicePressed
        id: _id_369
        source: id_369.value
        color: "#00000000"
        visible: diceClicked == 2 && root.page == 0? true : false
        readOnly: id_369.readOnly
        x:300*root.realscale
        y:500.5*root.realscale
        width:27.5*root.realscale
        height:29*root.realscale
    }
    ImageField {//ThrOpenDiceDisabled
        id: _id_371
        source: id_371.value
        color: "#00000000"
        visible: !getThrOpenEnabled() && root.page == 0? true : false
        readOnly: id_371.readOnly
        x:300*root.realscale
        y:500.5*root.realscale
        width:27.5*root.realscale
        height:29*root.realscale
    }

    TextInputField {//KarmaPoolQty
        id: _id_1716
        text: id_1716.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_1716.readOnly
        tooltip:""
        x:322*root.realscale
        y:48*root.realscale
        width:32.5*root.realscale
        height:30.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_1716.value = text
        }
    }
    TextInputField {//KarmaPoolAvlb
        id: _id_1717
        text: id_1717.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_1717.readOnly
        tooltip:""
        x:354*root.realscale
        y:48*root.realscale
        width:35*root.realscale
        height:30.5*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_1717.value = text
        }
    }
    TextInputField {//KarmaGoodQty
        id: _id_1718
        text: id_1718.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_1718.readOnly
        tooltip:""
        x:322*root.realscale
        y:78.5*root.realscale
        width:32.5*root.realscale
        height:32*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_1718.value = text
        }
    }
    TextInputField {//KarmaGoodAvlb
        id: _id_1719
        text: id_1719.value
        color:"#ff000000"
        backgroundColor: "#00000000"
        visible: root.page == 0? true : false
        readOnly: id_1719.readOnly
        tooltip:""
        x:354*root.realscale
        y:78.5*root.realscale
        width:35*root.realscale
        height:32*root.realscale
        hAlign: TextInput.AlignHCenter
        vAlign: TextInput.AlignVCenter
        font.family:  "Sans Serif"
        font.bold:    false
        font.italic:  false
        font.underline: false
        font.pointSize: 13
        font.overline: false
        font.strikeout: false
        onTextChanged: {
            id_1719.value = text
        }
    }

  }
}
