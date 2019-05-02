import os # for doing I/O
import urllib2 # for downloading files from UCI ML Repo
import zipfile # for unzipping downloaded files

# Location of first .zip file:
url_1 = "https://archive.ics.uci.edu/ml/machine-learning-databases/00222/bank.zip"
# Location of second .zip file:
url_2 = "https://archive.ics.uci.edu/ml/machine-learning-databases/00222/bank-additional.zip"

urls = [url_1, url_2]

os.chdir('..')
os.chdir('..')
os.chdir('data')
os.chdir('raw')

for url in urls:
    site = urllib2.urlopen(url) 
    fname = site.url.split('/')[-1] # our eventual filename
    data = site.read()
    f = open(fname, 'wb')
    print('Writing {} to file...'.format(fname))
    f.write(data)
    f.close()


# now unzip the files that we just downloaded:
to_unzip = os.listdir(os.getcwd())
for fname in to_unzip:
    subdirname = fname.split('.')[0]
    os.mkdir(subdirname)
    #fpath = '{}\\{}'.format(os.getcwd(),subdirname,fname)
    zip_ref = zipfile.ZipFile(fname, 'r')
    print('Unzipping file {}...'.format(fname))
    zip_ref.extractall(path=subdirname)
    zip_ref.close()
