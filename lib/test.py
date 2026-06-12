import requests

API_KEY = "여기에_API_키_입력"
url = f"http://openapi.seoul.go.kr:8088/45726e526b61746f393473494d4466/json/citydata/1/1/여의도한강공원"

resp = requests.get(url)
data = resp.json()

city = data.get('CITYDATA', {})
# print("=== CITYDATA 최상위 키 목록 ===")
# print(list(city.keys()))

# print("\n=== 따릉이 키 확인 ===")
# for key in city.keys():
#     if 'BIKE' in key or 'BICYCLE' in key or 'SBIKE' in key:
#         print(f"  발견: {key}")
#         print(f"  샘플: {city[key][:1]}")

# print("\n=== 주차장 키 확인 ===")
# for key in city.keys():
#     if 'PRK' in key or 'PARK' in key:
#         print(f"  발견: {key}")
#         print(f"  샘플: {city[key][:1]}")

# for p in city['PRK_STTS']:
#     print(p['PRK_NM'], '| CUR_PRK_YN:', p['CUR_PRK_YN'])

for p in city['PRK_STTS']:
    if p['CUR_PRK_YN'] == 'Y':
        print(p['PRK_NM'], '| CPCTY:', p['CPCTY'], '| CUR_PRK_CNT:', repr(p['CUR_PRK_CNT']), '| TIME:', repr(p['CUR_PRK_TIME']))