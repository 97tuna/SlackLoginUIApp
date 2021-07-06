# SlackLoginUIApp Clone Coding
<br>

<br>
<!-- SlackLoginUIApp 앱 사진 -->
<p align="center">
    <img width="400px" src="https://user-images.githubusercontent.com/50114556/124639239-e4e47380-dec6-11eb-9eb7-92618c37d768.gif">
</p>
<br>

## Clone Coding 목표
1. Slack 로그인 첫 페이지에서 workspace 주소를 입력한다. 입력과 동시에 placeholder에서 .slack.com만 남기고 자연스럽게 유저가 입력한 주소와 placeholder가 이어지는 듯한 효과를 주어야 함.
2. workspace URL을 입력할 때 영어 소문자, 숫자, -(하이픈) 이외에 입력은 제한할 것.
3. 두 번째 페이지에서 사용자가 이메일을 입력하면, 입력과 동시에 placeholder가 사라지고 위의 Label로 "Your email address"가 자연스럽게 올라오는 효과를 주어야 함.

## 버그 발견 및 수정 방법
화면을 표시하기 직전에 키보드의 위치를 먼저 알고 뷰에 반영하기 위해 옵저버를 사용하여 키보드가 올라와도 뷰를 가리지 않도록 설정하고자 하였음.
> 그러나 옵저버를 사용할 때 제작하면서 버그가 3가지가 있었다.

1. 첫 번째 화면에서 두 번째 화면으로 넘어갈 때 옵저버가 유지가 되면서 두 번째 화면의 키보드 위치를 첫 번째 화면으로 전달해 주면서 첫 번째 화면이 위로 올라가 조정 받으며 넘어갔다. 옵저버의 위치를 ViewWillAppear로 변경하여 화면에 표시되기 직전에 옵저버가 추가하였다. 미리 뷰 로드전에 하면 오류가 생기기 때문이다.

2. 두 번째 화면으로 넘어갈 때 아래서 위로 올라오는듯한 오류가 생겼다. 첫 번째 화면의 키보드 높이를 저장하고 있다가 두 번째 화면에서 사용하여 버그를 해결하였다.

3. 두 번째 페이지에서 첫 번째 페이지로 넘어올 때 animation이 안 나오는 이유는 delegate에서 animation을 false로 해둬서 animation 없이 표시되는 것이었다. 키보드가 표시된 다음 animation 다시 활성화하고자 present 변수를 두어서 animation을 제한했다가, 첫 번째 화면에서 키보드가 실행되면 제한을 풀어서 문제를 해결하였다.

## Developer
<table>
    <tr>
        <td align="center" width="135px">
            <a href="https://github.com/97tuna"><img height="100px" width="100px" src="https://avatars3.githubusercontent.com/u/50114556?s=400&v=4"></img></a><br />
            <sub> <b> 97tuna </b> </sub>
        </td>
    </tr>
</table>

<!-- 2021.07.07(WED) [UPD] update README.md -->
