<?php

class DataController extends CI_Controller{






    function __construct() {
        parent::__construct();
        $this->load->model('DataModel');
    }





    function generateCategoryData(){
        $this->load->helper('url');
        $data['category'] = $this->DataModel->getAllCategory();
        $json = json_encode($data);
        echo $json;
    }


    function AddAssignNumber() {
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('stdNumb','Mobile No.' ,'required');
        $this->form_validation->set_rules('formPutSerial', 'Mobile No.','required');
        $this->form_validation->set_rules('userCategory', 'Mobile No.',
            'required');
        $this->form_validation->set_rules('cardStat', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/admin'));
            } else {
            $data = array(
                'partyid' => $this->input->post('stdNumb'),
                'card_id' => $this->input->post('formPutSerial'),
                'userCatId' => $this->input->post('userCategory'),
                'createdBy' => $this->session->userdata('username'),
                'isDisabled' => $this->session->post('cardStat'),
                'createDate' => date('Y-m-d H:i:s')
            );

            $this->DataModel->saveAssignNumber($data);//Transfering data to Model
            $data['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/admin'));
        }
    }

    //This function gets data from the user and pass it to the model to be saved in the database.
    function ctl_AssignCardToUser() {
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('post_partyid','Mobile No.' ,'required');
        $this->form_validation->set_rules('post_cardId', 'Mobile No.','required');
        $this->form_validation->set_rules('post_userType', 'Mobile No.','required');
        $this->form_validation->set_rules('post_isDisabled','Mobile No.' ,'required');
        $cardId = $this->input->post('post_cardId');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'partyId' => $this->input->post('post_partyid'),
                'card_id' => $cardId,
                'categoryId' => $this->input->post('post_userType'),
                'createdBy' => $this->session->userdata('username'),
                'createDate' => date('Y-m-d H:i:s'),
                'updateDate' => date('Y-m-d H:i:s'),
                'isDisabled' => $this->input->post('post_isDisabled')
            );

            $this->DataModel->assignCardToUser($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            $postData2 = array(
                'card_id' => $cardId,
                'campus_status'=>"",
                'gate_id'=> "",
                'updatedate' =>date('Y-m-d H:i:s'),
            );
            $this->DataModel->mdl_AddGatePersonStatus($postData2);

            redirect(site_url('PageController/ActiveUsers'));
        }
    }







    function AddGateUserCategory() {
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('catType','Mobile No.' ,'required');
        $this->form_validation->set_rules('catName', 'Mobile No.','required');
        $this->form_validation->set_rules('catTime', 'Mobile No.','required');
        $this->form_validation->set_rules('absTime', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'categoryName' => $this->input->post('catName'),
                'categoryType' => $this->input->post('catType'),
                'gateTimeInSetting' => $this->input->post('catTime'),
                'gateTimeSettingAbsent' => $this->input->post('absTime'),
                'createdBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s')
            );

            $this->DataModel->insertNewUserCategory($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/UserCategoryList'));
        }
    }


    function ctl_editGateUserCategory() {
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('edit_catID','Mobile No.' ,'required');

        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {

                 $Id = $this->input->post('edit_catID');
                 $v1 = $this->input->post('edit_catName');
                 $v2 = $this->input->post('edit_catType');
                 $v3 = $this->input->post('edit_catTime');
                 $v4 = $this->input->post('edit_catAbsentTime');
                 $update =date('Y-m-d H:i:s');

            $this->DataModel->mdl_editGateUserCategory($Id, $v1,$v2,$v3,$v4, $update);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/UserCategoryList'));
        }
    }


    function ctl_deleteGateUserCategory() {
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('dlt_catID','Mobile No.' ,'required');

        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {

            $Id = $this->input->post('dlt_catID');

            $this->DataModel->mdl_deleteGateUserCategory($Id);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/UserCategoryList'));
        }
    }


    function rolekey_exists()
    {
        if(!filter_var($_POST["key"]))
        {
            echo '<label class="text-danger"><span class="glyphicon glyphicon-remove"></span> Invalid Email</span></label>';
        }
        else
        {
            $this->load->model("DataModel");
            if($this->DataModel->userId_exists($_POST["key"]))
            {
                echo '<label class="text-danger"><span class="glyphicon glyphicon-remove"></span> ID Already register</label>';
            }
            else
            {
                echo '<label class="text-success"><span class="glyphicon glyphicon-ok"></span> ID Available</label>';
            }
        }
    }





    function createNewRecordPerson(){

        $this->load->library('form_validation');

        $this->form_validation->set_rules('record_lastName','Mobile No.' ,'required');
        $this->form_validation->set_rules('record_givenName','Mobile No.' ,'required');
        $this->form_validation->set_rules('record_middleName','Mobile No.' ,'required');
        $this->form_validation->set_rules('slt_CivilStatus','Mobile No.' ,'required');
        $this->form_validation->set_rules('slt_Gender','Mobile No.' ,'required');


        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'userGivenId' => $this->input->post('record_existingUserID'),
                'familyname' => $this->input->post('record_lastName'),
                'givenname' => $this->input->post('record_givenName'),
                'middlename' => $this->input->post('record_middleName'),
                'suffix' => $this->input->post('record_suffix'),
                'mobile_number' => $this->input->post('record_mobile'),
                'civilStatus' => $this->input->post('slt_CivilStatus'),
                'gender' => $this->input->post('slt_Gender'),
                'dateofBirth' => $this->input->post('record_Birthday'),
                'age' => $this->input->post('record_age'),
                'categoryId' => $this->input->post('record_Category'),
                'createdBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s')
            );


            $this->DataModel->insertNewPersonRecord($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/ActiveUsers'));
        }
    }

    function ctl_EditUserRecordDetails(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('edit_studentID','Mobile No.' ,'required');
                if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $id= $this->input->post('edit_studentID');
            $postData = array(
                'userGivenId' => $this->input->post('edit_existingUserID'),
                'familyname' => $this->input->post('edit_lastName'),
                'givenname' => $this->input->post('edit_givenName'),
                'middlename' => $this->input->post('edit_middleName'),
                'suffix' => $this->input->post('edit_suffix'),
                'mobile_number' => $this->input->post('edit_mobile'),
                'civilStatus' => $this->input->post('edit_CivilStatus'),
                'gender' => $this->input->post('edit_Gender'),
                'dateofBirth' => $this->input->post('edit_Birthday'),
                'age' => $this->input->post('edit_age'),
                'categoryId' => $this->input->post('edit_Category'),
                'createdBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s')
            );
            $this->DataModel->mdl_EditUserRecordDetails($id,$postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/ActiveUsers'));
        }
    }

//This function edits the System header setting
    function ctl_editSystemHeader(){
        $postData = array(
            'header_name' => $this->input->post('p_header'),
            'updatedby' => $this->session->userdata('username'),
            'updatedat' => date('Y-m-d H:i:s')
        );
        $this->DataModel->mdl_editSystemHeader($postData);//Transfering data to Model
        $postData['message'] = 'Data Inserted Successfully';
        redirect(site_url('PageController/getHeaderSettings'));
    }




// This function Edits the Card details that is assigned to the student or teacher
    function ctl_EditCardAssignmentDetail(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('edit_userId','Mobile No.' ,'required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        }
        else {
                $id= $this->input->post('edit_userId');
                $card_id = $this->input->post('edit_userCardId');
                $status = $this->input->post('edit_cardStatus');
                $dates = date('Y-m-d H:i:s');
                $postData2 = array(
                    'card_id' => $card_id,
                    'campus_status'=>"",
                    'gate_id'=> "",
                    'updatedate' =>date('Y-m-d H:i:s'),
                );
            $this->DataModel->mdl_EditCardAssignmentDetail($id,$card_id,$status,$dates);//Transfering data to Model
            $this->DataModel->mdl_AddGatePersonStatus($postData2);
            redirect(site_url('PageController/cardList'));
        }
    }

        //This function uploads a gate logo for the gate page.
        function ctl_uploadGateLogo(){
            $this->load->library('form_validation');
            $this->form_validation->set_rules('FilePathName_upload','Mobile No.' ,'required');
            $config['upload_path'] = './ui/photo_library/';
            $config['allowed_types'] = 'jpg|gif|jpeg|png';
            $this->load->library('upload', $config);

            if($this->form_validation->run() == FALSE){
                redirect(site_url('PageController/ErrorPage'));
            }else
            {
                $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_upload');
                $imgData = array(
                    'image_url' => $imagepath,
                    'created_by' => $this->session->userdata('username'),
                    'updated_by' => $this->session->userdata('username'),
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s')
                );
            }
            $this->DataModel->mdl_saveGateLogo($imgData);
            $imgData['message'] = 'Data Inserted Successfully';
            if (!$this->upload->do_upload()) {
                $error = array('error' => $this->upload->display_errors());
                $this->load->view('uploadTry', $error);

            } else {
                $file_data = $this->upload->data();
                $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
                redirect(site_url('PageController/getLogoSettings'));
            }
        }

        //This function is an ajax call for the logo to always be updated. when changed
        function ctl_updateGateLogo(){
            $this->load->library('form_validation');
            $this->form_validation->set_rules('FilePathName_update','Mobile No.' ,'required');
            if ($this->form_validation->run() == FALSE) {
                redirect(site_url('PageController/ErrorPage'));
            } else {
                $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_update');
                $this->DataModel->mdl_updateGateLogo($imagepath);//Transfering data to Model
                $postData['message'] = 'Data Inserted Successfully';
                redirect(site_url('PageController/getLogoSettings'));
            }
        }

        //This function uploads a chosen Background image for Gate Screen
    function ctl_uploadGateBackground(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('FilePathName_upload','Mobile No.' ,'required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);

        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/ErrorPage'));
        }else
        {
            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_upload');
            $imgData = array(
                'background_url' => $imagepath,
                'created_by' => $this->session->userdata('username'),
                'updated_by' => $this->session->userdata('username'),
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->mdl_saveBackgroundImage($imgData);
        $imgData['message'] = 'Data Inserted Successfully';
        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
            redirect(site_url('PageController/getBackgroundSettings'));
        }
    }

    //This function updates the uploaded image url used for the gate page.
    function ctl_updateGateBackground(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('FilePathName_update','Mobile No.' ,'required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_update');
            $this->DataModel->mdl_updateBackgroundImage($imagepath);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/getBackgroundSettings'));
        }
    }





    function ctl_EditMsgTemplateDetails(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('msgId','Mobile No.' ,'required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $id= $this->input->post('msgId');
            $type= $this->input->post('msgType');
            $txt = $this->input->post('msgTxt');
            $updateby = $this->session->userdata('username');
            $dates = date('Y-m-d H:i:s');


            $this->DataModel->mdl_EditMsgTemplateDetail($id,$type,$txt,$updateby,$dates);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/msgTemplates'));
        }
    }



    function ctl_DeleteMsgTemplateDetails(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('dlt_msgId','Mobile No.' ,'required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $id= $this->input->post('dlt_msgId');
            $this->DataModel->mdl_DeleteMsgTemplateDetail($id);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/msgTemplates'));
        }
    }


    //This function is used to add the emergency contact of the user to be contacted when they tap the id on the scanner
    function ctl_AddPersonEmergencyContact(){
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('post_userContactid','Mobile No.' ,'required');
        $this->form_validation->set_rules('post_ContactName', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'contactName' => $this->input->post('post_ContactName'),
                'contactRelationship' => $this->input->post('post_Relation'),
                'contactNumber' => $this->input->post('post_Number'),
                'createDate' => date('Y-m-d H:i:s'),
                'createdBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s'),
                'personDetailId' => $this->input->post('post_userContactid')
            );
            $this->DataModel->mdl_AddPersonEmergencyContact($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/ActiveUsers'));
        }
    }

    public function ctl_getUserImageTimelineList(){

        $x = $this->DataModel->mdl_getUserImageTimeline();
        $data = array();

        foreach($x->result() as $r) {

            $data['url'] = array(
                $r->url
            );
        }


        echo json_encode($data);
    }

    function ctl_EditPersonEmergencyContact(){
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('edit_userContactid','Mobile No.' ,'required');
        $this->form_validation->set_rules('edit_ContactName', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
                $userid = $this->input->post('edit_userContactid');
                $v1 = $this->input->post('edit_ContactName');
                $v2 =$this->input->post('edit_Relation');
                $v3 =$this->input->post('edit_Number');
                $v4 = date('Y-m-d H:i:s');


            $this->DataModel->mdl_EditPersonEmergencyContact($v1,$v2,$v3,$v4,$userid);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/ActiveUsers'));
        }
    }


    function ctl_EditPersonContact(){
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('edit_userContactid','Mobile No.' ,'required');
        $this->form_validation->set_rules('edit_ContactName', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $userid = $this->input->post('edit_userContactid');
            $v1 = $this->input->post('edit_ContactName');
            $v2 =$this->input->post('edit_Relation');
            $v3 =$this->input->post('edit_Number');
            $v4 = date('Y-m-d H:i:s');


            $this->DataModel->mdl_EditPersonEmergencyContact($v1,$v2,$v3,$v4,$userid);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';
            redirect(site_url('PageController/guardianList'));
        }
    }




    function ctl_AddGateUserCourse(){
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('courseType','Mobile No.' ,'required');
        $this->form_validation->set_rules('courseName', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'courseName' => $this->input->post('courseType'),
                'courseType' => $this->input->post('courseName'),
                'createdBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s')
            );

            $this->DataModel->mdl_AddGateUserCourse($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/sysSettings'));
        }
    }


    function ctl_addMessageTemplate(){
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->form_validation->set_rules('msgType','Mobile No.' ,'required');
        $this->form_validation->set_rules('msgTxt', 'Mobile No.','required');
        if ($this->form_validation->run() == FALSE) {
            redirect(site_url('PageController/ErrorPage'));
        } else {
            $postData = array(
                'message_type' => $this->input->post('msgType'),
                'msg_text' => $this->input->post('msgTxt'),
                'createdBy' => $this->session->userdata('username'),
                'createDate' => date('Y-m-d H:i:s'),
                'updatedBy' => $this->session->userdata('username'),
                'updateDate' => date('Y-m-d H:i:s')
            );

            $this->DataModel->insertMessageTemplate($postData);//Transfering data to Model
            $postData['message'] = 'Data Inserted Successfully';

            redirect(site_url('PageController/msgTemplates'));
        }
    }









    function stdConn_list() {
        $results = $this->DataModel-> get_studentConn_list();
        echo json_encode($results);
    }




    public function getRecentGateTopUp()
    {
        $this->load->helper('url');
        $data2["getGateTopUp"] = $this->DataModel->getGateTopUp();

        $json = json_encode($data2);
        echo $json;
    }

    public function ctl_extractUserIdScan()
    {
        $this->load->helper('url');
        $data["userDataScanned"] = $this->DataModel->mdl_extractUserIdScan();
        $json = json_encode($data);
        echo $json;
    }


    public function CombinedPhotoUpload()
    {

        $this->load->library('form_validation');
        $this->form_validation->set_rules('stdNumb','Mobile No.','required');
        $this->form_validation->set_rules('FilePathName','Mobile No.','required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);


        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/reporting'));
        }else
        {

            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName');
            $imgData = array(
                'partyId' => $this->input->post('stdNumb'),
                'image_url' => $imagepath,
                'updateDate' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->connection_personImage($imgData);
        $imgData['message'] = 'Data Inserted Successfully';

        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name']; redirect(site_url('PageController/admin'));
        }


    }

    public function updateExistingUserPhoto()
    {

        $this->load->library('form_validation');
        $this->form_validation->set_rules('stdNumb','Mobile No.','required');
        $this->form_validation->set_rules('FilePathName','Mobile No.','required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);


        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/reporting'));
        }else
        {

            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName');
            $imgData = array(
                'partyId' => $this->input->post('stdNumb'),
                'image_url' => $imagepath,
                'updateDate' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->updateUserPhotoFile($imgData);
        $imgData['message'] = 'Data Inserted Successfully';

        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
            redirect(site_url('PageController/students'));
        }


    }

    public function uploadNewUserPhotoFile()
    {

        $this->load->library('form_validation');
        $this->form_validation->set_rules('up_stdNumb','Mobile No.','required');
        $this->form_validation->set_rules('FilePathName_upload','Mobile No.','required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);


        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/reporting'));
        }else
        {

            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_upload');
            $imgData = array(
                'partyId' => $this->input->post('up_stdNumb'),
                'image_url' => $imagepath,
                'updateDate' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->insertUserPhotoFile($imgData);
        $imgData['message'] = 'Data Inserted Successfully';

        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
            redirect(site_url('PageController/students'));
        }


    }

    public function ctl_uploadUserPhoto()
    {

        $this->load->library('form_validation');
        $this->form_validation->set_rules('post_PartyIdUpload','Mobile No.','required');
        $this->form_validation->set_rules('FilePathName_upload','Mobile No.','required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);


        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/ErrorPage'));
        }else
        {

            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_upload');
            $imgData = array(
                'personDetailId' => $this->input->post('post_PartyIdUpload'),
                'image_url' => $imagepath,
                'createdBy' => $this->session->userdata('username'),
                'createDate' => date('Y-m-d H:i:s'),
                'updateDate' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->mdl_uploadUserPhoto($imgData);
        $imgData['message'] = 'Data Inserted Successfully';

        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
            redirect(site_url('PageController/ActiveUsers'));
        }


    }


    public function ctl_updateExistingUserPhoto()
    {

        $this->load->library('form_validation');
        $this->form_validation->set_rules('post_PartyIdPhotoEdit','Mobile No.','required');
        $this->form_validation->set_rules('FilePathName_edit','Mobile No.','required');
        $config['upload_path'] = './ui/photo_library/';
        $config['allowed_types'] = 'jpg|gif|jpeg|png';
        $this->load->library('upload', $config);


        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/ErrorPage'));
        }else
        {

            $imagepath = 'ui/photo_library/'.$this->input->post('FilePathName_edit');
            $imgData = array(
                'personDetailId' => $this->input->post('post_PartyIdPhotoEdit'),
                'image_url' => $imagepath,
                'createdBy' => $this->session->userdata('username'),
                'createDate' => date('Y-m-d H:i:s'),
                'updateDate' => date('Y-m-d H:i:s')
            );
        }
        $this->DataModel->mdl_updateUserPhoto($imgData);
        $imgData['message'] = 'Data Inserted Successfully';

        if (!$this->upload->do_upload()) {
            $error = array('error' => $this->upload->display_errors());
            $this->load->view('uploadTry', $error);

        } else {
            $file_data = $this->upload->data();
            $data['img'] = base_url() . '/ui/photo_library/' . $file_data['file_name'];
            redirect(site_url('PageController/ActiveUsers'));
        }


    }


    //With Gsm module function
// This code checks the cardID and then pulls the record from the database.
// When the data is ready it will be queuing the msg to the msg database and wait until it it picked up by the process
public function ctl_buildSmsNotification(){
    $this->load->helper('url');
    $cardId =$this->input->post('crdScanned');
    $data = $this->DataModel->mdl_getGuardianNumber($cardId);
    $data2 = $this->DataModel->mdl_studentFamilyname($cardId);
    $data3 = $this->DataModel->mdl_studentGivenname($cardId);
    $status =  $this->DataModel->mdl_checkPersonCampusStatus($cardId);
    $json_data = json_decode(json_encode($data),true);
    $json_data2 = json_decode(json_encode($data2),true);
    $json_data3 = json_decode(json_encode($data3),true);
    $json_status =  json_decode(json_encode($status),true);
    $num = $json_data[0]['contactNumber'];
    $fname = $json_data2[0]['familyname'];
    $gname = $json_data3[0]['givenname'];
    $ustat = $json_status[0]['campus_status'];
    $timein = date('Y-m-d H:i:s');

        if($ustat == 0)
        {

            $temptype = 1;
            $data=$this->DataModel->mdl_getMessageTemplate($temptype);
            $json_data = json_decode(json_encode($data),true);
            $text = $json_data[0]['msg_text'];
            $intro = $json_data[0]['msg_intro'];
            $this->DataModel->mdl_updatePersonCampusStatusIn($cardId);

            $con_msg = $intro." , ". $fname ." , ".$gname ." ". $text;

            $post_smsPush = array(
                'sms_to' => $num,
                'message'=>$con_msg,
                'sms_status'=>'Pending',
                'createdon' =>date('Y-m-d H:i:s'),
                'updatedon' =>date('Y-m-d H:i:s')
            );

           $this->DataModel->mdl_addPendingSms($post_smsPush);
           redirect(site_url('PageController/loader'));

        }
        elseif($ustat == 1){
            $temptype = 2;
            $data=$this->DataModel->mdl_getMessageTemplate($temptype);
            $json_data = json_decode(json_encode($data),true);
            $text = $json_data[0]['msg_text'];
            $intro = $json_data[0]['msg_intro'];
            $this->DataModel->mdl_updatePersonCampusStatusOut($cardId);
            $con_msg = $intro ." , ". $fname ." , ".$gname ." ". $text;
                $post_smsPush = array(
                'sms_to' => $num,
                'message'=>$con_msg,
                'sms_status'=>'Pending',
                'createdon' =>date('Y-m-d H:i:s'),
                'updatedon' =>date('Y-m-d H:i:s')
            );
            $this->DataModel->mdl_addPendingSms($post_smsPush);
            redirect(site_url('PageController/loader'));

        }

 redirect(site_url('PageController/loader'));
}



//Contact List



//Function will be working with the 3rd party API that is itexmo
//This function just gets the post data from the card scan and then sends the data to the API of ItextMo using internet.
//Internet is needed for this to work.

public function ctl_createSmsNotification(){

    //GLOBAL VARIABLES FOR 3RD PARTY API
     $itextmo_token = 'TR-CALVI573914_DBR92';
     $itextmo_pwd = '}13]t}jp68';

  $this->load->helper('url');
  $cardId =$this->input->post('crdScanned');
  $details = $this->DataModel->mdl_getStudentGuardianContact($cardId);
  $status =  $this->DataModel->mdl_checkPersonCampusStatus($cardId);
  $json_data = json_decode(json_encode($details),true);
  $json_status =  json_decode(json_encode($status),true);
  $num = $json_data[0]['contactNumber'];
  $fname = $json_data[0]['familyname'];
  $gname = $json_data[0]['givenname'];
  $ustat = $json_status[0]['campus_status'];

      if($ustat == 0)
      {
          $temptype = 1;
          $data=$this->DataModel->mdl_getMessageTemplate($temptype);
          $json_data = json_decode(json_encode($data),true);
          $text = $json_data[0]['msg_text'];
          $intro = $json_data[0]['msg_intro'];
          $this->DataModel->mdl_updatePersonCampusStatusIn($cardId);

          $con_msg = $intro." ". $fname ." , ".$gname ." ". $text;

          $ch = curl_init();
          $itexmo = array('1' => $num
          ,'2' => $con_msg
          ,'3' => $itextmo_token
          ,'passwd' => $itextmo_pwd);

          curl_setopt($ch, CURLOPT_URL,"https://www.itexmo.com/php_api/api.php");
          curl_setopt($ch, CURLOPT_POST, 1);
          curl_setopt($ch, CURLOPT_POSTFIELDS,
              http_build_query($itexmo));
          curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
          curl_exec($ch);
          curl_close($ch);
          unset($itexmo);
          echo $con_msg;
      }
      elseif($ustat == 1){
          $temptype = 2;
          $data=$this->DataModel->mdl_getMessageTemplate($temptype);
          $json_data = json_decode(json_encode($data),true);
          $text = $json_data[0]['msg_text'];
          $intro = $json_data[0]['msg_intro'];
          $this->DataModel->mdl_updatePersonCampusStatusOut($cardId);

          $con_msg = $intro." ". $fname ." , ".$gname ." ". $text;

          $ch = curl_init();
          $itexmo = array('1' => $num
          ,'2' => $con_msg
          ,'3' => $itextmo_token
          ,'passwd' => $itextmo_pwd);

          curl_setopt($ch, CURLOPT_URL,"https://www.itexmo.com/php_api/api.php");
          curl_setopt($ch, CURLOPT_POST, 1);
          curl_setopt($ch, CURLOPT_POSTFIELDS,
              http_build_query($itexmo));
          curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
          curl_exec($ch);
          curl_close($ch);
          unset($itexmo);
          echo $con_msg;
      }
}





        public function ctl_deleteContactList(){
          $data =$this->input->post('dlt_ListId');
          $this->DataModel->mdl_deleteContactLists($data);
          redirect(site_url('PageController/manageUserContactList'));
        }

        public function ctl_createContactList(){

            $listName =$this->input->post('contactListName');
          $post_List = array(
          'contactlist_name' => $listName,
          'createdby'=>$this->session->userdata('username'),
          'createdon' =>date('Y-m-d H:i:s'),
          'updatedby'=>$this->session->userdata('username'),
          'updatedon' =>date('Y-m-d H:i:s')
        );

        $this->DataModel->mdl_saveContactList($post_List);
          redirect(site_url('PageController/manageUserContactList'));
        }

        // This function calls the model in the DataModel and pulls all contacts to generate the list. and show in the datatable.
        public function ctl_getAllContactsInList($id=null){
            $draw = intval($this->input->get("draw"));
            $start = intval($this->input->get("start"));
            $length = intval($this->input->get("length"));
            $query = $this->DataModel->mdl_getAllContactsInList($id);
            $data = array();
                foreach($query->result() as $r) {
                  $data[] = array(
                    $r->contactlistid,
                    $r->personDetailId,
                    $r->givenname,
                    $r->familyname,
                    $r->mobile_number,
                  );
                }
                $output = array(
                  "draw" => $draw,
                  "recordsTotal" => $query->num_rows(),
                  "recordsFiltered" => $query->num_rows(),
                  "data" => $data
                );
                echo json_encode($output);
    }

        //This function pulls all the available contacts entered in the system.
        public function ctl_getAllContactAvailable($id=null){

          $draw = intval($this->input->get("draw"));
          $start = intval($this->input->get("start"));
          $length = intval($this->input->get("length"));


          $dataList = $this->DataModel->getAllContactGateUserList($id);

          $data = array();

          foreach($dataList->result() as $r) {

            $data[] = array(
               $r->personDetailId,
               $r->userGivenId,
               $r->familyname,
               $r->givenname,
               $r->mobile_number,

            );
          }
          $output = array(
            "draw" => $draw,
            "recordsTotal" => $dataList->num_rows(),
            "recordsFiltered" => $dataList->num_rows(),
            "data" => $data
          );
          echo json_encode($output);
        }





    public function checkCardDetails(){
        $this->load->library('form_validation');
        $this->form_validation->set_rules('crdScanned','Mobile No.','required');
        $this->form_validation->set_rules('gateStationId','Mobile No.','required');
        if($this->form_validation->run() == FALSE){
            redirect(site_url('PageController/ErrorPage'));
        }
        else
        {
            $cardId =$this->input->post('crdScanned');
            $stationId = $this->input->post('gateStationId');
            $post_cardData = array(
            'card_id' => $cardId,
            'createDate' =>date('Y-m-d H:i:s'),
            'gate_id'=>$stationId
            );
           $this->DataModel->insertCardHistoryDetails($post_cardData);
           $data = $this->DataModel->mdl_extractUserDetails($cardId);

           return $this->output
                ->set_content_type('application/json')
                ->set_status_header(200)
                ->set_output(json_encode($data));
        }
    }

    //This function sends the bulk  SMS curl command to the ITEXTMO SMS API
    public function sendBulkSMSMessage(){

        //GLOBAL VARIABLES FOR 3RD PARTY API
        $itextmo_token = 'TR-CALVI573914_DBR92';
        $itextmo_pwd = '}13]t}jp68';

        $listid =$this->input->post('contactListId');
        $postMsg = $this->input->post('message');
        $data = $this->DataModel->mdl_getContactNumbers($listid);
        $json =  json_decode(json_encode($data),true);
        $res_arr_values = array();
        foreach ($json as $item) {
            $res_arr_values[] = array('1' => $item["mobile_number"]
                                     ,'2' => $postMsg
                                     ,'3' => $itextmo_token
                                     ,'passwd' => $itextmo_pwd);
                                }
            foreach ($res_arr_values as $sms_curl){
                    try{
                        $ch = curl_init();
                        curl_setopt($ch, CURLOPT_URL,"https://www.itexmo.com/php_api/api.php");
                        curl_setopt($ch, CURLOPT_POST, 1);
                        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($sms_curl));
                        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                        curl_exec($ch);
                        curl_close($ch);

                    }
                    catch(Exception $e){
                        echo 'Caught exception: ',  $e->getMessage(), "\n";
                    }
                }

        unset($res_arr_values);
        }



//    public function makeBulkMessageSms(){
//      $this->load->helper('url');
//      $postMsg =$this->input->post('message');
//      $data = $this->DataModel->mdl_getStudentNumbers();
//      $json =  json_decode(json_encode($data),true);
//      foreach ($json as $item) {
//          $createSms = array(
//          'sms_to' => $item['mobile_number'],
//          'message' =>$postMsg,
//          'sms_status'=>'Pending'
//          );
//          $this->DataModel->mdl_addPendingSms($createSms);
//      }
//      redirect(site_url('PageController/broadcast'));
//    }

//      public function makeBulkMessageSmsToList(){
//        print_r($_POST);
//        $listid =$this->input->post('contactListId');
//        $postMsg = $this->input->post('message');
//        $data = $this->DataModel->mdl_getContactNumbers($listid);
//        $json =  json_decode(json_encode($data),true);
//        foreach ($json as $item) {
//            $createSms = array(
//            'sms_to' => $item['mobile_number'],
//            'message' =>$postMsg,
//            'sms_status'=>'Pending'
//            );
//            $this->DataModel->mdl_addPendingSms($createSms);
//      }
//      redirect(site_url('PageController/broadcastToList'));
//    }

      //Function that calls all numbers of Available Teachers
//      public function makeBulkMessageSmsTeach(){
//        $this->load->helper('url');
//        $postMsg =$this->input->post('message');
//        $data = $this->DataModel->mdl_getStaffNumbers();
//        $json =  json_decode(json_encode($data),true);
//        foreach ($json as $item) {
//            $createSms = array(
//            'sms_to' => $item['mobile_number'],
//            'message' =>$postMsg,
//            'sms_status'=>'Pending'
//            );
//            $this->DataModel->mdl_addPendingSms($createSms);
//        }
//        redirect(site_url('PageController/broadcastTeacher'));
//    }

        //Function that calls all numbers of Available Guardian Contacts
//        public function makeBulkMessageSmsGuardian(){
//          $this->load->helper('url');
//          $postMsg =$this->input->post('message');
//          $data = $this->DataModel->mdl_getAllGuardianContact();
//          $json =  json_decode(json_encode($data),true);
//          foreach ($json as $item) {
//              $createSms = array(
//              'sms_to' => $item['contactNumber'],
//              'message' =>$postMsg,
//              'sms_status'=>'Pending'
//              );
//              $this->DataModel->mdl_addPendingSms($createSms);
//          }redirect(site_url('PageController/broadcastGuardian'));
//    }



//        public function makeBulkMessageSmsAll(){
//
//          $this->load->helper('url');
//          $postMsg =$this->input->post('message');
//          $data = $this->DataModel->mdl_getAllNumbers();
//          $json =  json_decode(json_encode($data),true);
//          foreach ($json as $item) {
//
//              $createSms = array(
//              'sms_to' => $item['mobile_number'],
//              'message' =>$postMsg,
//              'sms_status'=>'Pending'
//              );
//              $this->DataModel->mdl_addPendingSms($createSms);
//            //print_r($createSms);
//
//          }redirect(site_url('PageController/broadcastAll'));
//    }



     //This function deletes the contact user in the contact list.
      public function ctl_deleteContactinList(){
         $userid =$this->input->post('dlt_removecontactId');
         $listid =$this->input->post('dlt_removeListId');
         $this->DataModel->mdl_removeContactInList($userid,$listid);
         redirect(site_url('PageController/editUserContactList/').$listid);
      }

    //This function adds an available contact to the chosen contact list
        public function ctl_insertContactToList(){
        $listid =$this->input->post('dlt_ListId');
        $contactid =$this->input->post('dlt_contactId');
        $number =$this->input->post('dlt_contactNumber');
        $postData = array(
                           'contactlistid' => $listid,
                           'personDetailId'=> $contactid,
                           'mobile_number'=> $number,
                           'createdby' =>$this->session->userdata('username'),
                           'createdon'=>date('Y-m-d H:i:s'),
                           'updatedby' =>$this->session->userdata('username'),
                           'updatedon' =>date('Y-m-d H:i:s'),
                         );
        $this->DataModel->addUserToContactList($postData);
        redirect(site_url('PageController/editUserContactList/').$listid);
        }


        //This function gets the contact lists and shows the in the add recipient in announcement page.
        public function ctl_getContactList(){
        $contacts = $this->DataModel->mdl_getAllContactLists();
            return $this->output
                ->set_content_type('application/json')
                ->set_status_header(200)
                ->set_output(json_encode($contacts));
        }













    }
?>
