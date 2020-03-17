
<html>

<?php require('StyleBundle.php')?>
<?php require('ScriptBundle.php')?>

<body style="background-color: white;">
<section>
    <h3 style="text-align: center;">History</h3>
    <table class="table">
        <thead>
        <?php
        if(isset($history)){
            foreach ($history as $obj){?>
                <tr style="padding-bottom: 5px;">
                    <th><img src="<?php  echo base_url();echo $obj->url?>" style="height: 100px; width: 100px;"></th>
                    <th><?php echo $obj->TimeIn?></th>
                </tr>

                <?php
            }
        }else{
            ' ';
        }
        ?>
        </thead>
    </table>
</section>
</body>
</html>
