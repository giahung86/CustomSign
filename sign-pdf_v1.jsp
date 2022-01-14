<%@ page import="java.util.Enumeration" %>
<%@ page import="vn.com.fss.tax.common.util.CompareUtil" %>
<%@ page import="vn.com.fss.tax.common.util.Util" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    //Lay thong tin Ma VB và Loại VB
    String functionId = "", ma_vb = "", loai_vb = "";
    Enumeration iteName = request.getParameterNames();
    while (iteName.hasMoreElements()) {
        String key = (String) iteName.nextElement();
        if(CompareUtil.isEquals(key, "function-id"))
            functionId = request.getParameter(key);
        else if(CompareUtil.isEquals(key, "ma"))
            ma_vb = request.getParameter(key);
        else if(CompareUtil.isEquals(key, "loai"))
            loai_vb = request.getParameter(key);
    }

    //hung.nguyen: test get cookies to send for signer
    Cookie[] cookies = request.getCookies();
    String myCookies = "";
    if(cookies != null && cookies.length > 0)
        myCookies = Util.toJson(cookies);
%>

<div id="model-name" style="display: none;">sign-pdf</div>
<div id="myCookies" style="display: none;"><%= myCookies%></div>

<style type="text/css">
    .print-bar{
        text-align: left;
        padding-bottom: 5px;
        border-bottom: solid 1px gray;
        margin-bottom: 2px;
    }
    .print-content{
        text-align: center;
        overflow-x: hidden;
        overflow-y: scroll;
        height: 500px;
    }
</style>
<div class="">
    <div id="msg_wrapper">
        <div class="${Success ? 'alert alert-success alert-dismissible' : Success == false ? 'alert alert-danger alert-dismissible' : 'hidden'}"
             role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
            </button>
            <span class="${Success ? 'glyphicon glyphicon-ok-circle' : Success == false ? 'glyphicon glyphicon-remove-circle' : ''}"></span>&nbsp;&nbsp;${Message}
        </div>
    </div>
    <form id="form" action="" method="POST" modelAttribute="formDataModel">
        <div id="container" class="form-horizontal">
            <div class="row">
                <div class="form-group col-sm-12 col-md-12 col-lg-12 ">
                    <h4>Ký số văn bản đính kèm</h4>
                </div>
            </div>
            <div class="row">
                <div class="form-group hidden">
                    <select id="signMethod" class="form-control " single readonly="readonly" no-temp="true" >
                        <option value="SHA-1" selected parentId=''>SHA-1</option>
                        <option value="SHA-256" parentId=''>SHA-256</option>
                    </select>
                    <input type="hidden" id="signMethod_value" name="signMethod" value="SHA-256"/>
                    <input type="hidden" id="signSerials" name="signSerials" value='[]'/>
                    <input type="hidden" id="signCustoms" name="signCustoms" value=''/>
                    <input type="hidden" id="functionId" name="functionId" value="<%= functionId%>" />
                    <input type="hidden" id="loai_vb" name="loai_vb" value="<%= loai_vb%>" />
                    <input type="hidden" id="ma_vb" name="ma_vb" value="<%= ma_vb%>" />
                    <input type="hidden" id="ten_file_moi" name="ten_file_moi" value="" />
                    <input type="hidden" id="noi_dung_file" name="noi_dung_file" value="" />
                </div>
                <div class="form-group col-sm-12 col-md-6 col-lg-6">
                    <label for="pdf_file" class="control-label col-sm-12 col-md-5 col-lg-3 text-require">Văn bản đính kèm (*)</label>
                    <div class="col-sm-12 col-md-7 col-lg-9" id="pdf_file_wrapper">
                        <input type="file" id="pdf_file" name="pdf_file" value="" class="form-control "
                               multiFiles="false" showFileList="true" maxFileSize="1048576" extensions=".pdf .PDF"
                               file_name_to="ten_file_moi" file_data_to="noi_dung_file"/>
                        <div id="pdf_file-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
                <div class="form-group col-sm-12 col-md-6 col-lg-6">
                    <label for="readFile" class="sr-only ">&nbsp;</label>
                    <div class="" id="readFile_wrapper">
                        <button type="button" id="readFile" class="btn btn-default"><span
                                class='k-icon k-i-folder-up'></span> Xem trước
                        </button>
                        <div id="readFile-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-sm-12 col-md-3 col-lg-3">
                    <label for="so_vb" class="control-label col-sm-12 col-md-5 col-lg-5 text-require" placeholder="Số văn bản..." >Số văn bản (*)</label>
                    <div class="col-sm-12 col-md-7 col-lg-7" id="so_vb_wrapper" style="">
                        <input type="text" id="so_vb" name="so_vb" value="" class="form-control " placeholder="Số văn bản..." />
                        <div id="so_vb-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
                <div class="form-group col-sm-12 col-md-3 col-lg-3">
                    <label for="ngay_vb" class="control-label col-sm-12 col-md-5 col-lg-5 text-require">Ngày văn bản (*)</label>
                    <div class="col-sm-12 col-md-7 col-lg-7" id="ngay_vb_wrapper" style="">
                        <input type="date" id="ngay_vb" name="ngay_vb" value="today" class="form-control " format ="dd/MM/yyyy" max="today" />
                        <div id="ngay_vb-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
                <div class="form-group col-sm-12 col-md-3 col-lg-3">
                    <label for="ghi_chu_vb" class="control-label col-sm-12 col-md-5 col-lg-5 text-require" placeholder="Ghi chú..." >Ghi chú</label>
                    <div class="col-sm-12 col-md-7 col-lg-7" id="ghi_chu_vb_wrapper" style="">
                        <input type="text" id="ghi_chu_vb" name="ghi_chu_vb" value="" class="form-control " placeholder="Ghi chú..." />
                        <div id="ghi_chu_vb-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
                <div class="form-group col-sm-12 col-md-3 col-lg-3">
                    <label for="sign_file" class="sr-only ">&nbsp;</label>
                    <div class="" id="sign_file_wrapper">
                        <button type="button" id="sign_file" class="btn btn-primary"><span
                                class='k-icon k-i-tick'></span> Ký số và Ghi dữ liệu
                        </button>
                        <div id="sign_file-notice" class="help-block bg-danger"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-sm-12 col-md-12 col-lg-12 ">
                    <h4>Xem trước văn bản đính kèm</h4>
                    <div class="print-bar">
                        <button type="button" id="prev" class="btn btn-default">Trang trước</button>
                        <button type="button" id="next" class="btn btn-default">Trang tiếp</button>
                        &nbsp; &nbsp;
                        <span>Trang: <input type="number" min="1" step="1" format="n0" decimals="0" de id="page_num"/> / Tổng số trang: <span id="page_count"></span></span>
                        &nbsp; &nbsp;
                        <button type="button" id="locate" class="btn btn-default">Chọn vị trí ký số</button>
                        <span id="locate_sign"></span>
                    </div>
                    <div class="print-content" style="position: relative;">
                        <canvas id="locate-canvas" style="border:1px solid orange; visibility: hidden; position: absolute;"></canvas>
                        <canvas id="print-canvas" style="border:1px solid gray;" width="838" height="595"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script src='<c:url value="/resources/vendor/pdf-js/1.10.88/pdf.js?v=xx3"/>'></script>

<script>
    $(document).ready(function () {
        //init config
        var pdfDoc = null,
            pageTotal = 0,
            pageNum = 1,
            pageRendering = false,
            pageNumPending = null,
            scale = 1,
            canvas = document.getElementById('print-canvas'),
            ctx = canvas.getContext('2d'),
            isLocate = false,
            canvas_locate = document.getElementById('locate-canvas'),
            ctx_locate = canvas_locate.getContext('2d'),
            BB = canvas_locate.getBoundingClientRect(),
            offsetX = BB.left,
            offsetY = BB.top,
            WIDTH = canvas_locate.width,
            HEIGHT = canvas_locate.height,
            dragok = false,
            startX = 20,
            startY = 10,
            initScroll = 0,
            shape = {p:pageNum,x:startX,y:startY,width:220,height:63,fill:"#ffff00",isDragging:false}
            ;

        /**
         * Get page info from document, resize canvas accordingly, and render page.
         * @param num Page number.
         */
        function renderPage(num) {
            pageRendering = true;
            // Using promise to fetch the page
            pdfDoc.getPage(num).then(function (page) {
                var viewport = page.getViewport(canvas.width / page.getViewport(scale).width);
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                canvas_locate.height = viewport.height;
                canvas_locate.width = viewport.width;

                // Render PDF page into canvas context
                var renderContext = {
                    canvasContext: ctx,
                    viewport: viewport
                };
                var renderTask = page.render(renderContext);

                // Wait for rendering to finish
                renderTask.promise.then(function () {
                    pageRendering = false;
                    if (pageNumPending !== null) {
                        // New page rendering is pending
                        renderPage(pageNumPending);
                        pageNumPending = null;
                    }
                    if(isLocate && shape.p === pageNum){
                        //refresh current location
                        customLocate();
                    }
                });

                // Update page counters
                var num = $('#page_num').data("kendoNumericTextBox");
                num.value(pageNum);
            });
        }

        /**
         * If another page rendering in progress, waits until the rendering is
         * finised. Otherwise, executes rendering immediately.
         */
        function queueRenderPage(num) {
            if (pageRendering) {
                pageNumPending = num;
            } else {
                renderPage(num);
            }
        }

        /**
         * Displays previous page.
         */
        function onPrevPage() {
            if (pageNum <= 1) {
                return;
            }
            pageNum--;
            queueRenderPage(pageNum);
        }

        /**
         * Displays next page.
         */
        function onNextPage() {
            if (pageNum >= pageTotal) {
                return;
            }
            pageNum++;
            queueRenderPage(pageNum);
        }

        /**
         * Displays enter page.
         */
        function onEnterPage(newPage) {
            if (newPage <= 1) {
                newPage = 1;
            }
            if (newPage >= pageTotal) {
                newPage = pageTotal;
            }
            if(newPage === pageNum)
                return;

            pageNum = newPage;
            queueRenderPage(pageNum);
        }

        /**
         * Get location to sign PDF
         */
        function onLocate() {
            if(pdfDoc && canvas_locate && ctx_locate){
                if(isLocate){
                    //remove custom location
                    resetLocate();
                }
                else{
                    //init default location
                    customLocate();
                }
            }
        }

        //dang ky su kien
        var pageNumber = $("#page_num");
        var pageCount = $("#page_count");
        var next = $("#next");
        var prev = $("#prev");
        var locate = $("#locate");
        var locate_sign = $("#locate_sign");
        var signCustoms = $("#signCustoms");
        next.on( "click", onNextPage);
        prev.on( "click", onPrevPage);
        locate.on( "click", onLocate);
        pageNumber.on( "change", function (e) {
            var  newPage = $(e.target).val();
            if(newPage)
                onEnterPage(parseInt(newPage));
        });

        // listen for mouse events
        canvas_locate.onmousedown = onMouseDown;
        canvas_locate.onmouseup = onMouseUp;
        canvas_locate.onmousemove = onMouseMove;

        //Get the file from the input element
        var readFile = $("#readFile");
        readFile.on( "click", function() {
            var pdfs = $("#pdf_file").data("kendoUpload");
            var files = pdfs.getFiles();
            if (!files || files.length <= 0) {
                myBox.showWarning("Chưa có file đính kèm nào được chọn để xem");
                return;
            }
            var file = files[0].rawFile;
            //Step 2: Read the file using file reader
            var fileReader = new FileReader();
            fileReader.onload = function() {
                //Step 4:turn array buffer into typed array
                var typedarray = new Uint8Array(this.result);
                //Step 5:PDFJS should be able to read this
                PDFJS.getDocument(typedarray).then(function(pdf) {
                    pdfDoc = pdf;
                    pageTotal = pdfDoc.numPages;
                    pageCount.text(pageTotal);

                    // Initial/first page rendering
                    renderPage(pageNum);
                });
            };
            //Step 3:Read the file as ArrayBuffer
            fileReader.readAsArrayBuffer(file);
        });

        var signFile = $("#sign_file");
        signFile.on( "click", function() {
            var elementId = "#main-content";
            var formData = extractFormDataToJson(elementId);
            if(!validateData(formData))
                return;

            var date = parseDateSearch(formData.ngay_vb);
            formData.ngay_vb = formatDateJson(date);
            //hung.nguyen: bo sung cookies de gui sang signer
            formData.cookies = $("#myCookies").text();
            kySoDuLieuVanBan(formData, formData.functionId, "noi_dung_file");
        });

        //handler ky so file and submit
        function validateData(formData) {
            if(!formData.functionId || formData.functionId === "") {
                myBox.showError('Tham số dữ liệu cần ký số không hợp lệ, không xác định được văn bản nguồn');
                return false;
            }
            if(!formData.ma_vb || formData.ma_vb === "") {
                myBox.showError('Tham số dữ liệu cần ký số không hợp lệ, không xác định được văn bản nguồn');
                return false;
            }
            if(!formData.loai_vb || formData.loai_vb === "") {
                myBox.showError('Tham số dữ liệu cần ký số không hợp lệ, không xác định được văn bản nguồn');
                return false;
            }
            if(!formData.ten_file_moi || formData.ten_file_moi === "") {
                myBox.showError('Tài liệu cần ký số đính kèm văn bản là bắt buộc', function () {
                    $("#pdf_file").focus();
                });
                return false;
            }
            if(!formData.so_vb || formData.so_vb === "") {
                myBox.showError('Trường dữ liệu Số văn bản là bắt buộc nhập', function () {
                    $("#so_vb").focus();
                });
                return false;
            }
            if(!formData.ngay_vb || formData.ngay_vb === "") {
                myBox.showError('Trường dữ liệu Ngày văn bản là bắt buộc nhập', function () {
                    $("#ngay_vb").focus();
                });
                return false;
            }
            return true;
        }

        //handler get signature location
        function customLocate() {
            isLocate = true;
            shape.p = pageNum;
            locate.text("Hủy bỏ chọn");
            locate_sign.text("page: " + shape.p +" - startX: " + shape.x + " - startY: " + shape.y);
            signCustoms.val(JSON.stringify(shape));
            $(canvas_locate).css("visibility", "visible");
            $(canvas_locate).css("z-index", "1000");
            //refresh canvas size
            BB = canvas_locate.getBoundingClientRect();
            offsetX = BB.left;
            offsetY = BB.top;
            WIDTH = canvas_locate.width;
            HEIGHT = canvas_locate.height;
            if(window.scrollY > 0 || canvas_locate.parentElement.scrollTop > 0)
                initScroll = window.scrollY + canvas_locate.parentElement.scrollTop;
            // call to draw the scene
            reDrawFrame();
        }
        //reset to default location
        function resetLocate() {
            isLocate = false;
            startX = 20;
            startY = 10;
            shape.p = pageNum;
            shape.x = startX;
            shape.y = startY;
            initScroll = 0;
            locate.text("Chọn vị trí ký số");
            locate_sign.text("");
            signCustoms.val("");
            $(canvas_locate).css("visibility", "hidden");
            $(canvas_locate).css("z-index", "-1");
            clearRect();
        }
        // draw a single rect
        function drawRect(r) {
            var w = r.width + 100;
            var h = r.height + 30;
            ctx_locate.fillStyle = r.fill;
            ctx_locate.fillRect(r.x, r.y, w, h);
            ctx_locate.restore();
        }
        // clear the canvas
        function clearRect() {
            ctx_locate.clearRect(0, 0, WIDTH, HEIGHT);
        }
        // redraw the scene
        function reDrawFrame() {
            clearRect();
            drawRect(shape);
        }

        // handle mousedown events
        function onMouseDown(e){
            if(!isLocate || shape.p !== pageNum) return;

            // tell the browser we're handling this mouse event
            e.preventDefault();
            e.stopPropagation();

            // get the current mouse position
            var mx=parseInt(e.clientX-offsetX);
            var my=parseInt(e.clientY-offsetY);
            var myScroll = my + e.srcElement.parentElement.scrollTop + window.scrollY - initScroll;

            // test each shape to see if mouse is inside
            dragok=false;
            // decide if the shape is a rect or circle
            var w = shape.width + 100;
            var h = shape.height + 30;
            if(shape.width){
                // test if the mouse is inside this rect
                if(mx>shape.x && mx<shape.x+w && myScroll>shape.y && myScroll<shape.y+h){
                    // if yes, set that rects isDragging=true
                    dragok=true;
                    shape.isDragging=true;
                    // save the current mouse position
                    startX = mx;
                    startY = my;
                    shape.p = pageNum;
                    locate_sign.text("page: " + shape.p +" - startX: " + shape.x + " - startY: " + shape.y);
                    signCustoms.val(JSON.stringify(shape));
                }
            }
        }
        // handle mouseup events
        function onMouseUp(e){
            if(!isLocate || shape.p !== pageNum) return;

            // tell the browser we're handling this mouse event
            e.preventDefault();
            e.stopPropagation();

            // clear all the dragging flag
            dragok = false;
            shape.isDragging=false;
        }
        // handle mouse moves
        function onMouseMove(e){
            if(!isLocate || shape.p !== pageNum) return;

            // if we're dragging anything...
            if (dragok){
                // tell the browser we're handling this mouse event
                e.preventDefault();
                e.stopPropagation();

                // get the current mouse position
                var mx=parseInt(e.clientX-offsetX);
                var my=parseInt(e.clientY-offsetY);

                // calculate the distance the mouse has moved
                // since the last mousemove
                var dx=mx-startX;
                var dy=my-startY;

                // move each rect that isDragging
                // by the distance the mouse has moved
                // since the last mousemove
                if(shape.isDragging){
                    shape.x+=dx;
                    shape.y+=dy;
                }
                // redraw the scene with the new rect positions
                reDrawFrame();

                // reset the starting mouse position for the next mousemove
                startX = mx;
                startY = my;
                shape.p = pageNum;
                locate_sign.text("page: " + shape.p +" - startX: " + shape.x + " - startY: " + shape.y);
                signCustoms.val(JSON.stringify(shape));
            }
        }
    });
</script>
