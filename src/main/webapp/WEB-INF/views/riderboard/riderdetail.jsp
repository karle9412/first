<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
  #board  input     { width:100%; }
  #board  textarea  { width:100%; height: 400px;  }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
window.onload = function(){
replylist();


}


function RRFU(reply_number, i){
console.log(i);
let html="";
html += '<form action="RRF/RRFU" method="POST" enctype="multipart/form-data">';
html += '<input type="hidden" name="board_number" value="${riderBoardVo.board_number}"></input>'
html += '<input type="hidden" name="menu_id" value="${menu_id}"></input>'
html += '<input type="hidden" name="rider_reply_number" value=' + reply_number + '></input>'
html += '<input type="file" name="filename" ></input>';
html += '<button type="submit">파일보내기</input>';
html += '</form>';
$('[name=fileUpload'+i+']').html(html);

}

function DeleteBoard(){
  let ans = confirm("삭제하시겠습니까?");
  if(ans){
    if("${nickName}" != "${riderBoardVo.writer}"){
      alert("본인이 작성한 게시글만 삭제 가능합니다");
    }
    else{
      $.ajax({
        type:"get",
        url:"/Board/RBoardDelete?board_number=${riderBoardVo.board_number}&menu_id=${menu_id}",
        success:function(result){
          alert("삭제되었습니다");
          location.href='/Board/riderList?menu_id=MENU_02&pageNum=1&contentNum=10';
        }
      });
    }
  }
}

function updateReplyForm(reply_number,writer){
  let k = document.getElementById("R"+reply_number);
  if("${nickName}" != writer){
    alert("본인이 작성한 댓글만 수정 가능합니다.");
  }
  else{
    const writer_check =confirm("수정하시겠습니까?");
    let k = document.getElementById("R"+reply_number);
    let form = "";

    form += '<div>';
    form += '<input type= "hidden" name="reply_numbery" id ="reply_number" value= '+reply_number+'>';
    form += '<input type= "hidden"  name="writer" id= "writer" value='+ writer +'>'
    form += '<textarea class = "replyclass" id= "replycontent" cols="80" rows="3">';
    form += k.textContent;
    form += "</textarea>";
    form += "<br/>";
    form +='<button type = "button" class="Updatebtn" onClick="updateReply(' + reply_number +',\'' + writer + '\')"> 완료 </button>';
    form +='<button type = "button" class="DeleteBtn" onClick="replylist()" >';
    form += '취소';
    form += '</button>';
    form += '</div>';
    form += '</br>';
    document.getElementById("R"+reply_number).innerHTML = form;
    $("[name=replyupdateBtn]").css('display', 'none');
    $("[name=replydeleteBtn]").css('display', 'none');
  }
}

function updateReply(reply_number, writer){
  let reply_content = $("#replycontent").val();
  let replynumber = reply_number;
  let reply_writer = writer;
  let updateurl = "/Board/R_replyUpdate?reply_number=";
  let updateurl1= "&cont="
  let param = {"cont":reply_content, "reply_number":replynumber, "writer":reply_writer};

  $.ajax({
    type: "POST",
    url: updateurl + replynumber + updateurl1 + reply_content,
    data: param,
    success: function(result){
      alert("댓글이  수정되었습니다");
      replylist();
    },
    error: function(error_){
      if($('#replycontent').val() == ''){
        alert('댓글을 입력해주세요.')
      }
    }
  });
}

function deleteReply(reply_number,writer){
  let deleturl = "/Board/R_ReplyDelete?reply_number="
  let DeleteReply_number = reply_number
  let ans = confirm("삭제하시겠습니까?");
  if("${nickName}" != writer){
    alert("본인이 작성한 댓글만 삭제 가능합니다");
  }
  else{
    if(ans === true){
      $.ajax({
        type: "POST",
        url: deleturl + DeleteReply_number,
        success: function(deleteresult){
          alert("댓글이 삭제되었습니다");
          let total   = ${replyPager.totalCount} - 1;
          let contentnum = ${replyPager.pageNum+1} * 10;
          if ((contentnum - total) == 10 ){
            location.href='/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum='+ ${replyPager.pageNum} +'&contentNum='+ contentnum +'';
          }
          else{
            location.href='/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum=${replyPager.pageNum+1}&contentNum=${replyPager.contentNum}';
          }
        }
      });
    }
  }
}
</script>
</head>
<body>
<table id="board">
  <caption><h2>내용 보기</h2></caption>
  <tr>
    <td>번호</td>
    <td>${ riderBoardVo.board_number }</td>
  <tr>
    <td>작성일</td>
    <td>${ riderBoardVo.indate }</td>
    <td>작성자</td>
    <td>${ riderBoardVo.writer }</td>
  </tr>
  <tr>
    <td>제목</td>
    <td colspan="3">${ riderBoardVo.title }</td>
  </tr>
  <tr>
    <div id = "startline">
    <td>출발지</td>
    <td >${riderBoardVo.r_start}</td>
    <td>목적지</td>
    <td>${riderBoardVo.r_end}</td>
    <td>일자</td>
    <td>${riderBoardVo.delivery_indate}</td>
    </div>
  </tr>
  <tr>
    <td>비용</td>
    <td>${riderBoardVo.money}</td>
    <td>수화물</td>
    <td>${riderBoardVo.luggage}</td>
  </tr>
  <tr>
    <td>내용</td>
    <td colspan="3">${ riderBoardVo.cont }</td>
  </tr>
  <tr>
    <td colspan="4"></td>
    <form name = "RUpdateBoard" method = "get">
      <input type = "hidden" name ="board_number" value= "${riderBoardVo.board_number}"/>
      <input type = "hidden" name = "menu_id" value= "${menu_id}"/>
      <input type = "hidden" name=  "writer"  value = "${riderBoardVo.writer}"/>
      <button type = "button" id = "update" onClick = "UpdateBoard_()">수정</button>
    </form>
    <input type = "button" id = "delete" value= "삭제" onclick = "DeleteBoard()"</button>
    [<a href="/Board/riderList?menu_id=MENU_02&pageNum=${boardPager.getPageNum()+1}&contentNum=${(boardPager.getPageNum()+1)*10}">목록으로</a>]
    [<a href="javascript:history.back()">이전으로</a>]
    [<a href="/">Home</a>]
  </tr>
</table>
<table id="reply1">
<div id="reply">
  <ol class="replyList">
    <c:forEach items="${replylist}" var="replylist">
      <p>
      작성자 : ${replylist.writer}<br />
      작성 날짜 :${replylist.indate}
      </p>
      <p>${replylist.cont}</p>
    </c:forEach>
  </ol>
</div>
</table>
<div id = Replyli></div>
<div style="width:700px; text-align:center;">
  <br>
    <textarea rows ="5" cols="80" id="replytext" placeholder="댓글을 작성하세요"></textarea>
    <button type="button" id="btnReply" class="btnReply">작성</button>
  </br>
</div>
<div id =ReplyPa></div>
<script>
$("#btnReply").click(function(){
  let cont  = $("#replytext").val();
  let board_number = "${riderBoardVo.board_number }";
  let menu_id = "${menu_id}";
  let writer = "${nickName}"
  let param = {"cont":cont, "board_number":board_number, "menu_id":menu_id, "writer":writer};
  $.ajax({
    type: "post",
    url: "/Board/RidreplyWrite",
    data: param,
    success: function(result){
      alert("댓글이 등록되었습니다");
      $("#replytext").val('');
      window.location.reload();
      replylist();
    }
  });
});

function replylist(list){
  $.ajax({
    type:"get",
    url: "/Board/RReplyList?board_number=${riderBoardVo.board_number}&menu_id=${menu_id}&pageNum=${map.pageNum}&contentNum=${map.contentNum}",
    success: function(resultList){
      console.log(resultList);
      let html = "";
      let RPager = "";

      if (resultList.length >0){
        html += '<table>';
        let end = parseInt(resultList[0].rend_page)
        let startP = parseInt("${replyPager.getStartPage()}");
        console.log(startP);
        console.log(end);
        for(var i =0; i<resultList.length; i++){
          html += '<tr>';
          html += '<td>';
          html += resultList[i].writer;
          html += '</td>';
          html += '</tr>';
          html += '<tr>';
          html += '<td id="R'+ resultList[i].reply_number +'">';
          html += resultList[i].cont;
          html += '</td>';
          html += '</tr>';
          html += '<tr>';
          html +='<td>';
          html += resultList[i].indate;
          html +='</td>';
          html +='<td>';
          html +='<button type="button" class="btn" name = "RRFU" onclick="RRFU('+ resultList[i].reply_number + ','+ i +')">사진 올리기</button>';
          html +='<span name="fileUpload' + [i] + '"></span>'
          html += '</td>';
          html +='<td>';
          html +='<button type="button" class="btn" name = "replyupdateBtn" onclick="updateReplyForm('+ resultList[i].reply_number + ',\'' + resultList[i].writer +'\')">수정</button>';
          html += '</td>';
          html += '<td>';
          html +='<button type="button" class="btndelte" name = "replydeleteBtn" onclick="deleteReply('+ resultList[i].reply_number + ',\'' + resultList[i].writer +'\')">삭제</button>';
          html +='</td>'
          html+= '<td>';
                                  html+= '<button type="button" class="checkbtn" name="checkbtnbtn" onclick="checkbutton()">접수하기</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+= '<button type="button" class="checkbtnbtn" name="checkbtn" onclick="checkbuttonbtn()">접수완료</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+= '<button type="button" class="checkbtnbtn" name="checkbtn" onclick="checkdelitebtn()">접수취소</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+=  '<input type="button" onclick="sendSMS()" value="전송하기" />'
                                  html+= '</td>';
                                  html+= '</tr>';
          html += '</tr>';
        }
        html+='</table>';
        $('#Replyli').html(html);

        RPager += '</table>';
        RPager += '<table id="pager">';
        RPager += '<tr>';
        RPager += '<td>';
        RPager += '<c:if test="${replyPager.prev}">';
        RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum=${replyPager.getStartPage()-1}&contentNum=${(replyPager.getStartPage()-1)*10}">< 이전</a>';
        RPager += '</c:if>';
        RPager += '</td>';
        RPager += '<td>';
        for (var j=startP; j<=end; j++){
          RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum='+j+'&contentNum='+j*10+'">'+j+'</a>';
        }
        RPager += '</td>';
        RPager += '<td>';
        if("${replyPager.next}"=="true"){
           RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum=${replyPager.getEndPage()+1}&contentNum=${(replyPager.getEndPage()+1)*10}">다음 ></a>';
        }
        RPager += '</td>';
        RPager += '</tr>';
        RPager += '</table>';
        $('#ReplyPa').html(RPager);
      }
      else{
        html += '<table>';
        let end = ""
        let startP = parseInt("${replyPager.getStartPage()}");

        for(var i =0; i<resultList.length; i++){
          html += '<tr>';
          html += '<td>';
          html += resultList[i].writer;
          html += '</td>';
          html += '</tr>';
          html += '<tr>';
          html += '<td id="R'+ resultList[i].reply_number +'">';
          html += resultList[i].cont;
          html += '</td>';
          html += '</tr>';
          html += '<tr>';
          html +='<td>';
          html += resultList[i].indate;
          html +='</td>';
          html +='<td>';
          html+='<button type="button" class="btn" name = "RRFU" onclick="RRFU('+ resultList[i].reply_number + ','+ i +')">사진 올리기</button>';
          html+='<span name="fileUpload' + [i] + '"></span>'
          html+= '</td>';
          html +='<td>';
          html +='<button type="button" class="btn" name = "replyupdateBtn" onclick="updateReplyForm('+ resultList[i].reply_number + ',\'' + resultList[i].writer +'\')">수정</button>';
          html += '</td>';
          html += '<td>';
          html +='<button type="button" class="btndelte" name = "replydeleteBtn" onclick="deleteReply('+ resultList[i].reply_number + ',\'' + resultList[i].writer +'\')">삭제</button>';
          html +='</td>'
                                  html+= '<td>';
                                  html+= '<button type="button" class="checkbtn" name="checkbtnbtn" onclick="checkbutton()">접수하기</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+= '<button type="button" class="checkbtnbtn" name="checkbtn" onclick="checkbuttonbtn()">접수완료</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+= '<button type="button" class="checkbtnbtn" name="checkbtn" onclick="checkdelitebtn()">접수취소</button>';
                                  html+= '</td>';
                                  html+= '<td>';
                                  html+=  '<input type="button" onclick="sendSMS()" value="전송하기" />'
                                  html+= '</td>';
                                  html+= '</tr>';
          html += '</tr>';
        }
        html+='</table>';
        $('#Replyli').html(html);

        RPager += '</table>';
        RPager += '<table id="pager">';
        RPager += '<tr>';
        RPager += '<td>';
        RPager += '<c:if test="${replyPager.prev}">';
        RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum=${replyPager.getStartPage()-1}&contentNum=${(replyPager.getStartPage()-1)*10}">< 이전</a>';
        RPager += '</c:if>';
        RPager += '</td>';
        RPager += '<td>';
        for (var j=startP; j<=end; j++){
          RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum='+j+'&contentNum='+j*10+'">'+j+'</a>';
        }
        RPager += '</td>';
        RPager += '<td>';
        if("${replyPager.next}"=="true"){
           RPager += '<a href="/Board/riderDetail?board_number=${replyPager.board_number}&menu_id=${menu_id}&pageNum=${replyPager.getEndPage()+1}&contentNum=${(replyPager.getEndPage()+1)*10}">다음 ></a>';
        }
        RPager += '</td>';
        RPager += '</tr>';
        RPager += '</table>';
        $('#ReplyPa').html(RPager);
      }
    }
  });
}

function UpdateBoard_(){
  if("${nickName}" != "${riderBoardVo.writer}"){
    alert("본인이 작성한 게시글만 수정 가능합니다");
  }
  else{
    $("#update").on("click", function(){
      let formobj = $("form[name='RUpdateBoard']");
      formobj.attr("action", "/Board/RBoardUpdateForm");
      formobj.submit();
    });
  }
}




           function checkbutton(){
                 let checkcheck = 1
                 let ggg = {"board_check": checkcheck}
                 let ans = confirm("접수하시겠습니까?");
                 let a = "${riderBoardVo.writer}"
                 let b = "${nickName}"
                   if (ans === false){
                   return false;}
                     if("${riderBoardVo.board_check}" == 2){
                       alert("이미 접수완료된 게시글입니다.")
                       return false;
                       }
                 if(a != b){
                 alert("본인이 작성한 게시글만 접수 가능합니다")
                 }
                 else{
                   $.ajax({
                   type:"get",
                   url:"/Board/Rcheck?board_number=${riderBoardVo.board_number}&menu_id=${menu_id}",
                   data: ggg,
                   success:function(resultcheck){
                   alert("접수완료")
                   location.href='/Board/riderDetail?board_number=${riderBoardVo.board_number}&menu_id=MENU_02&pageNum=1&contentNum=10&board_check=1';
                   }
                   })
                 }
               }

              function checkbuttonbtn(){
                let checkcheck = 2;
                    let ggg = {"board_check": checkcheck}
                    let ans = confirm("접수완료 시 취소가 불가능합니다.");
                    let a = "${riderBoardVo.writer}"
                    let b = "${nickName}"
                    if(ans === true){
                    if(a != b){
                    alert("본인이 작성한 게시글만 접수 가능합니다")
                    }
                    else{
                      $.ajax({
                      type:"get",
                      url:"/Board/Rcheck?board_number=${riderBoardVo.board_number}&menu_id=${menu_id}",
                      data: ggg,
                      success:function(resultcheck){
                      alert("접수완료")
                      location.href='/Board/riderDetail?board_number=${riderBoardVo.board_number}&menu_id=MENU_02&pageNum=1&contentNum=10&board_check=2';
                      }
                      })
                      }
                      }

                  }

</script>
</body>
</html>