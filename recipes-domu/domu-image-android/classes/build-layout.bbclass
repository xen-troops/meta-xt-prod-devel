def build_layout(d):
    urls = d.getVar('SRC_URI', True).split()
    workdir = d.getVar('WORKDIR', True) + '/'

    for url in urls:
       _, _, _, _, _, p = decodeurl(url)
       if 'builddir' in p.keys():
          # if there is one folder in the subdir - it will be
          # renamed into builddir and moved, if more - all items will be 
          # moved under buildir
          items = os.listdir(workdir + p['subdir'])

          if len(items) == 0:
             continue
          src_dir = workdir + p['subdir']
          dst_dir = workdir + p['builddir']

          if not os.path.exists(dst_dir):
                os.makedirs(dst_dir)
          if len(items) == 1:
             copy_directory(src_dir +'/'+ items[0], dst_dir)
          elif len(items) > 1:
             for item in items:
                 copy_directory(src_dir +'/'+ +item, dst_dir)

    
def decodeurl(url):
    import re
    import collections
    import urllib.parse
    
    m = re.compile('(?P<type>[^:]*)://((?P<user>[^/;]+)@)?(?P<location>[^;]+)(;(?P<parm>.*))?').match(url)
    if not m:
       raise MalformedUrl(url)

    type = m.group('type')
    location = m.group('location')
    if not location:
       raise MalformedUrl(url)
    user = m.group('user')
    parm = m.group('parm')

    locidx = location.find('/')
    if locidx != -1 and type.lower() != 'file':
       host = location[:locidx]
       path = location[locidx:]
    elif type.lower() == 'file':
       host = ""
       path = location
    else:
       host = location
       path = "/"
    if user:
       m = re.compile('(?P<user>[^:]+)(:?(?P<pswd>.*))').match(user)
       if m:
          user = m.group('user')
          pswd = m.group('pswd')
    else:
       user = ''
       pswd = ''

    p = collections.OrderedDict()
    if parm:
       for s in parm.split(';'):
          if s:
             if not '=' in s:
                raise MalformedUrl(url, "The URL: '%s' is invalid: parameter %s does not specify a value (missing '=')" % (url, s))
             s1, s2 = s.split('=')
             p[s1] = s2

    return type, host, urllib.parse.unquote(path), user, pswd, p

    
def copy_directory(src,dst):
    import shutil
    for item in os.listdir(src):
       s = os.path.join(src, item)
       d = os.path.join(dst, item)
       if os.path.isdir(s):
          shutil.copytree(s,d)
       else:
          shutil.copy2(s, d)

