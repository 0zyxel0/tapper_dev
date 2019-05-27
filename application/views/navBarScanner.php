<script>
    $.ajax({
            type: "GET",
            url: "<?php echo site_url('PageController/getHeaderTitle'); ?>",
            success: function (data) {
                var json = JSON.parse(data);
                var getTitle = JSON.stringify(json[0]["header_name"]);
                var cleanTitleString = getTitle.substring(1, getTitle.length-1);
                document.getElementsByClassName("headerDiv")[0].getElementsByTagName('a')[0].innerHTML=cleanTitleString;
            }


        }
    );

</script>


<nav class="navbar navbar-inverse navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>

                <div style="margin-left: 300px;" class="headerDiv"><a class="navbar-brand" href="<?php if($_SESSION['username']== 'Admin'){echo site_url('PageController/reporting');}elseif($_SESSION['username']=='Gate'){echo site_url('PageController/gate');}   ?>"></a></div>
                <div style="background-color: #00CC00; margin-left:150px; width: 120px; height:150px;position:absolute;"></div>

            </div>

            <ul class="nav navbar-top-links navbar-right">
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>

                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#"><i class="fa fa-user fa-fw"></i> <?= $this->session->userdata('username') ?></a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="<?= site_url('PageController/logout') ?>"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->
        </nav>