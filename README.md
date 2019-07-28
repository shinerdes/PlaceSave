# pod 

pod 'Firebase/Core'
pod 'SwiftyJSON'
pod 'EzPopup'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Firebase/Database'
pod 'GoogleUtilities', '5.2.3'




# LoginVC

Only google 계정만 가능 

# MapVC

1. Pin이 가르키는 위치를 바로바로 label에 나오게 함
2. 각 카테고리별로 camera가 잡고 있는 화면의 근처에 있는 가게들 위치가 
    카테고리의 아이콘으로 등장
3. 해당하는 가게의 아이콘을 클릭시 pin은 안보이게 하고,  해당하는 가게의 이미지와 이름을 xib로 보여지게 함
4. offset을 기준으로 marker가 활성화 되어있는지 아닌지 판단
5. marker를 저장할경우 offset으로 marker가 현재 활성화 되어있는지, 
    그리고 해당하는 장소가 이미 저장된 장소 인지 ( 이부분은 로그인 된 계정, 위도, 경도를 기준으로 중복성을 체크한다.) 확인하고,
    이상이 없다면 database와 storage에 각각 저장
6. xib에 바로 버튼을 추가하지 못해서 데이터를 저장하는 과정이 간단하게 안끝나고 marker -> popupmenu의 과정으로 돌아간 이유는 
   (Googlemap 대리인은 인포오브에서 탭 제스처를 감지하는 탭 기능을 제공하지만, 전체 인포오브 이미지가므로 버튼이 상호 작용하도록 할 수 없으므로 이를 중심으로 작업해야 한다!)


# TypeChangeVC, MenuPopVC 

EzPopup pod을 활용해 카테고리 변경, 데이터 저장 view의 이동, marker 데이터 저장의 기능을 선택할 수 있게 함


# SavePlaceVC

1. database에 있는 REF_POINTS 데이터에서 email이 현재 로그인되어있는 email과 같은 것만 1차적으로 뽑아낸다.
2. tableview에 가게 이미지, 가게 이름, 가게 주소, 가게 위도 / 경도를 나타낸다.


# Servies - DataService, AuthService 

firebase 로그인을 위한 




