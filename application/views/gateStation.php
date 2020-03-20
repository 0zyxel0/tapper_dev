<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">



    <?php require('StyleBundle.php')?>
    <?php require('ScriptBundle.php')?>
    <script type="text/javascript">
        $(document).ready(function() {

            var dt = new Date();
            var time = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();



            $('#changing').css('opacity', 0);
            $('#cardScan').on('submit',function(e){
                var post_data1 = $('#crdScanned').val();
                var post_data2 = $('#gateStationId').val();
				console.log(post_data1);
                $.ajax({
                    url: "<?php echo site_url('DataController/checkCardDetails'); ?>",
                    type: 'POST',
                    cache: false,
                    data: { crdScanned: post_data1,
                        gateStationId: post_data2
                    }, // This is all you have to change
                    success: function (data) {
						console.log(data);
                        $('#crdScanned').val('');
                       var userData = data[0];
                       var db_image_path =userData.image_url;
                       var image_path_concat = '<?php echo base_url()?>' + db_image_path;
                        $("#scanned_user_pic").attr('src',image_path_concat);
                        $("#scanned_user_id").text(userData.userGivenId);
                        $("#scanned_user_name").text(userData.familyname+ ' ' +userData.givenname);
                        $("#scanned_user_timestamp").text(time);
                        showScannedDetails();
                        setTimeout( function(){
                            hideScannedDetails();
                            clearScannedDetails();
                        }  , 1000 );
                    }
                }
                  

            );
				sendSmsNotification(post_data1);
                reload_gateTimelineHistory();
                return false;

            });

            function sendSmsNotification(post_data1){
                $.ajax({
                    url: "<?php echo site_url('DataController/ctl_createSmsNotification'); ?>",
                    type: 'POST',
                    cache: false,
                    data: { crdScanned: post_data1
                    }, // This is all you have to change
                    success: function (data) {
                        console.log(data);
                    }
                });return false;
            }


            function showScannedDetails(){
                $('#changing').css('opacity', 100);
            }
            function hideScannedDetails(){
                $('#changing').css('opacity', 0);
            }
            function clearScannedDetails(){

                $("#scanned_user_pic").removeAttr('src');
                $("#scanned_user_id").text("");
                $("#scanned_user_name").text("");
                $("#scanned_user_timestamp").text("");
            }


            function reload_gateTimelineHistory(){
                document.getElementById('gateIframe').contentWindow.location.reload();
            }


        });
    </script>
    <style>
        .sidebar{
            background-color:#eee;
            position: absolute;
            top: 0;
            bottom: 0;
            right: 0;
        }
        input:focus {
            background-color: transparent;
        }
    </style>
</head>
<body style="background-image: url(<?php
if(isset($background)){
    foreach ($background as $obj){
        echo base_url(); echo $obj->background_url;
    }
}else{
    ' ';
}

?>); overflow: hidden;">
    <div class="wrapper">
    <?php require('navBarScanner.php')?>
        <div class="row" style="padding-top:8%;">
            <div class="col-md-5 col-md-offset-3">
                    <div class="panel-body" id="changing" style="background-color: white;">
                            <div class="table-responsive">
                                <table class="table">
                                    <tbody>
                                    <td colspan="2" style="text-align: center; border-color: transparent;">
                                         <img id="scanned_user_pic" src="" width="400" height="400">
                                    </td>
                                    </tbody>
                                    <tbody>
                                            <tr>
                                                <th>User ID</th>
                                                <td id="scanned_user_id"></td>
                                            </tr>
                                            <tr>
                                                <th>Name</th>
                                                <td id="scanned_user_name"></td>
                                            </tr>
                                            <tr>
                                                <th>Time Stamp</th>
                                                <td id="scanned_user_timestamp"></td>
                                            </tr>
                                    </tbody>
                                </table>
                            </div>
                </div>
            </div>
        </div>

            <div class="panel" style="position: absolute; bottom: 0; margin-left:39%;margin-right:49%; opacity:70%;">
                <div class="panel-title" style="text-align: center;padding-top:5px;">
                    <span style="color:grey;"><B>ID CODE</B> </span>
                </div>
                <div class="panel-body">
                    <form id="cardScan" method="post" autocomplete="off">

                        <input name="crdScanned" id="crdScanned" value=""  maxlength="10" autofocus>
                        <!--                            <input class="form-control"  name="gateStationId" id="gateStationId" value="GTONE" autofocus>-->
                        <!--                            <button id="btnCheck" class="btn btn-primary btn-lg btn-block">check</button>-->
                        <!--                                <input name="crdScanned" id="crdScanned" value=""  maxlength="10" style=" background: transparent;border: solid; color:#f8f8f8; width:500px;   outline-width: 0; opacity: 0;"  autofocus>-->
                        <input class="form-control"  name="gateStationId" id="gateStationId" value="GTONE" type="hidden" autofocus>
                        <button id="btnCheck" class="btn btn-primary btn-lg btn-block" style="display: none;">check</button>


                    </form>
                </div>
            </div>

        <div class="col-xs-4 sidebar" style="background-color: white;">
            <iframe id="gateIframe" width="100%" height="100%" src="<?php echo site_url('PageController/ctl_gateTimelineHistory');?>"  frameBorder="0" scrolling="no"></iframe>
        </div>
    </div>
</body>
</html>
