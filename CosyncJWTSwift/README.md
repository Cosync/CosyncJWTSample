# CosyncJWTSample

1. Install the pods needed to run CosyncJWTSample

    > pod install

2. Edit the Constants.swift file with your Realm instance parameters

```
	MY_INSTANCE_ADDRESS should point to your instance address e.g. 
	"testapplication1.us2a.cloud.realm.io"
   
	APP_TOKEN get this from CosyncJWT portal Application Detail keys tab e.g.
   
"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjhkMjRkNzZhYjIyYTQzNjhiZjM4YzczYTM0OTk1N2E5Iiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODc0ODI5NTl9.IhxRe8eCznYTyqy7Kjal28Y-Lh6k7la5ubf5KedCAVvNixezo2OpTN-GHsy_xlZCQSdz7Si6NxRRD6_JWU-UCo3SldTWneptNupA5h5PwkqMaCW4v4gT-bQtu4d0quK7TGh2j8kdFchLPCOstT3i5-zzsRXQSnfsgP9g0fIutla8fZj3kJ2PJvGrfI4HVwCBWyGNZ_JZI97h7fvbEa8B5AVUpYFktm2CX_zxT0b3oXLNfPi1ZEMSlJXqZEkrDmzyOe3NWVzoiVfXWX2B03MJD3dZ8MZrbH8qWbAJnJIVblViRbs1-NVWPefAYojd2qvxOYAb2vHOKh_gsn26gbRULA"

	SUPERUSER_ACCESS_TOKEN if you need to call `setAppData` CosyncJWT REST function, you
	can get this from "Show Super User Token" in the keys tab of Application Detail. e.g.
  
"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI0ZTY5MmNmNjMzMjE0NjYzOTIwMmVkYmM3NGZhOTAzMSIsImFwcElkIjoiZjQ3MTU1MzEzOWMxNGM2ZWJiMDdiMzRjMjYwMzcyMGMiLCJzY29wZSI6ImRldmVsb3BlciIsImlhdCI6MTU4NzQxODYyM30.2KEGkASUwmATQ57M5oVfAKD8AV4hrB6453Bn4jHZ5K4OUOkdeE3s3Pu1Fo964Iaj2_RQzjNdh1zpHQD2V_BOakfiIAIifYObscGX5IpIDzzhlM67t1wCPXY8xlPLT_d608CudZNEHPdNs6W713ne57h0PgqBRSvAHBDFAcoLEyD60SUYK1vMGgASPnG4_x43Ru1hO93uZPNppxJQpo1SffQwPQmB4Va2EHu1Ublau_OY7vsbT-AecfWMyIvx1VdPZ6Hva6v-Nn4SGTpj0BM0zUqjYxEqhb6d3hTvLxhCLN4-qUhE7BC3-mD3eFWrQG9nhxigcmY7mgLdQqJj_lrXsw"
```
Both APP_TOKEN and SUPERUSER_ACCESS_TOKEN are JWT tokens that can be inspected using [jwt.io](https://jwt.io)
  


3. Build and run application to test it
