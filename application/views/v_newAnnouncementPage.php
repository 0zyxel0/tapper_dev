<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tapper</title>

    <?php require('StyleBundle.php')?>
    <?php require('ScriptBundle.php')?>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

<div id="wrapper">
    <?php require('navBar.php')?>

    <div id="page-wrapper">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Send New Announcement</h1>
                </div>


                <div class="panel-heading">
                    <form id="form" action="<?= site_url('DataController/sendBulkSMSMessage') ?>" method="post" accept-charset="utf-8" autocomplete="off" class="form-signin" role="form" data-parsley-validate="">
                            <label>Contact List</label>
                            <select class="form-control" name="contactListId" id="contactListId" required="">
                                <option value="" selected disabled>-------</option>
                                <?php

                                foreach($lists as $row)
                                {
                                    echo '<option value="'.$row->contactlistid.'">'.$row->contactlist_name.'</option>';
                                }
                                ?>
                            </select>
                            <br/>
                            <label>Message</label>
                            <br/>
                            <textarea name="message" id="message" class="form-control" rows="5" required=""></textarea>
                            <br/>
                            <br/>
                            <a href="#" class="btn btn-lg btn-primary btn-block" data-toggle="modal" data-target="#myModal" id="openSendModal">Send</a>

                        <!-- Modal -->
                                <div id="myModal" class="modal fade" role="dialog">
                                    <div class="modal-dialog">

                                        <!-- Modal content-->
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                              <h4>Recipient Count : </h4>
                                            </div>
                                            <div class="modal-body" id="messageModalBody">

                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                                                <button class="btn btn-success" type="submit">Send</button>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                        </form>

                    </form>
                </div>

            </div>
        </div>
    </div>


</div>


<script>
    $(document).ready(function() {

        $("#openSendModal").click(function() {
            getMsgContent();
        });


        function getMsgContent(){
            $( ".msg_p" ).remove();
            var msg  = $("#message").val();
            $("#messageModalBody").append('<p class="msg_p">'+ msg +'</p>');
        }



    });
</script>


</body>

</html>