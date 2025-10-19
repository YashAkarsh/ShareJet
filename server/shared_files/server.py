from fastapi import FastAPI,UploadFile,File
from fastapi.responses import FileResponse
from pathlib import Path
import shutil
import os
import uvicorn
from fastapi.middleware.cors import CORSMiddleware


app=FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (change to your Flutter app domain for security)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


UPLOAD_FOLDER=Path('shared_files')
PENDING_FOLDER=Path('pending_files')
UPLOAD_FOLDER.mkdir(exist_ok=True)
p_files=os.listdir(PENDING_FOLDER)

@app.get('/')
def read_root():
    response={
        'message': 'Server ran successfully!',
        'files_pending':len(os.listdir(os.path.join('pending_files','YashPhone'))),
    }
    return {'Message':'Server ran successfully!'}

@app.get('/download/{device_name}')
def download_files(device_name:str):
    print('herhe')
    files=os.listdir(os.path.join('pending_files',device_name))
    print(files)
    for file in files:

        file_path=os.path.join(PENDING_FOLDER,device_name,file)
        # if len(p_files)!=0 and os.path.exists(file_path):
        #     for file in p_files:
        return FileResponse(path=file_path,filename=file)
        # else:
        #     print('''
        #         Transfer Failed!
        #         Message: No such file.
        #         ''')

@app.post('/upload')
def upload_files(files:list[UploadFile]=File(...)):
    responses=[]
    for file in files: 
        file_path=UPLOAD_FOLDER/file.filename
        with open(file_path,'wb') as buffer:
            shutil.copyfileobj(file.file,buffer)
        responses.append({'Message': f'{file.filename} uploaded successfully'})
    return responses

if __name__=='__main__':
    uvicorn.run('server:app',host='0.0.0.0',port=8000,reload=True)
