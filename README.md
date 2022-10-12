# pod 

pod 'Firebase/Core'
pod 'SwiftyJSON'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Firebase/Database'
pod 'GoogleUtilities', '5.2.3'


# 구글 Firebase 요금제 이슈로 기본요금제로 설정 하였습니다.
# 기본요금제 설정에서는 맵에 스토어 아이콘들이 보여지지 않음.

# LoginVC

Only google 계정만 가능 

# MapVC

1. Pin이 가르키는 위치를 바로바로 label에 나오게 함
2. 각 카테고리별로 camera가 잡고 있는 화면의 근처에 있는 가게들 위치가 
    카테고리의 아이콘으로 등장
3. 해당하는 가게의 아이콘을 클릭시 pin은 안보이게 함.
    팝업창으로 가게의 이미지와 이름을 보여지게 함. 팝업창에서 저장을 하게 되면 데이터베이스에 가게 정보가 저장
4. 해당하는 장소가 이미 저장된 장소 인지 ( 이부분은 로그인 된 계정, 위도, 경도를 기준으로 중복성을 체크한다.) 확인하고,
    이상이 없다면 database와 storage에 각각 저장

# StoreTypeTableVC

기존에 있던 ezpop을 활용한 MenuPopVC를 제거하고, tableView로 상점의 카테고리를 설정하는 뷰로 대체

# TabBar - MacVC, SavePlaceVC를 선택

# TypeChangeVC(제거), MenuPopVC(제거), ezpop cocoapod (제거)

# SavePlaceVC

1. database에 있는 REF_POINTS 데이터에서 email이 현재 로그인되어있는 email과 같은 것만 1차적으로 뽑아낸다.
2. tableview에 가게 이미지, 가게 이름, 가게 주소, 가게 위도 / 경도를 나타낸다.

# Servies - DataService, AuthService 






