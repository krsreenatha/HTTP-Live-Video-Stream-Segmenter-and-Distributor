require 'mkmf'

$LIBS << " #{ENV["LIBS"]}"
$CFLAGS << " -Wall -g #{ENV["CFLAGS"]}"

have_library('avformat')
have_library('avcodec')
have_library('avutil')
have_library('bz2')
have_library('m')
have_library('z')
have_library('faac')
have_library('mp3lame')
have_library('x264')
have_library('faad')
have_library('pthread')

def create(target)
  libpath = $LIBPATH
  rm_f "conftest*"
  message "creating Makefile\n"

  if not $objs
    $objs = []
    srcs = Dir["*.{#{SRC_EXT.join(%q{,})}}"]
    for f in srcs
      obj = File.basename(f, ".*") << ".o"
      $objs.push(obj) unless $objs.index(obj)
    end
  elsif !(srcs = $srcs)
    srcs = $objs.collect {|obj| obj.sub(/\.o\z/, '.c')}
  end
  $srcs = srcs
  for i in $objs
    i.sub!(/\.o\z/, ".#{$OBJEXT}")
  end

  libpath = libpathflag(libpath)

  mfile = open("Makefile", "wb")
  n = "$(TARGET)"
  mfile.print "
TARGET = #{target}
CC = #{CONFIG['CC']}
CFLAGS   = #{CONFIG['CCDLFLAGS']} #$CFLAGS #$ARCH_FLAG
INCFLAGS = -I. #$INCFLAGS
LDSHARED = $(CC)
LIBPATH = #{libpath}
LIBS = #{$libs} #{$LIBS}
SRCS = #{srcs.collect(&File.method(:basename)).join(' ')}
OBJS = #{$objs}
CLEANLIBS     = #{n}.#{CONFIG['DLEXT']} #{n}.il? #{n}.tds #{n}.map #{n}
CLEANOBJS     = *.#{$OBJEXT} *.#{$LIBEXT} *.s[ol] *.pdb *.exp *.bak
CLEANFILES = #{$cleanfiles.join(' ')}
DISTCLEANFILES = #{$distcleanfiles.join(' ')}
MAKEDIRS = #{config_string('MAKEDIRS') || '@$(RUBY) -run -e mkdir -- -p'}
COPY = #{config_string('CP') || '@$(RUBY) -run -e cp -- -v'}

"

  CXX_EXT.each do |ext|
    COMPILE_RULES.each do |rule|
      mfile.printf(rule, ext, $OBJEXT)
      mfile.printf("\n\t%s\n\n", COMPILE_CXX)
    end
  end
  %w[c].each do |ext|
    COMPILE_RULES.each do |rule|
      mfile.printf(rule, ext, $OBJEXT)
      mfile.printf("\n\t%s\n\n", COMPILE_C)
    end
  end

  mfile.print "$(TARGET) : "
  mfile.print "$(OBJS) Makefile\n"
  mfile.print "\t@-$(RM) $@\n"
  link_so = LINK_SO.gsub(/^/, "\t")
  mfile.print link_so, "\n\n"
  mfile.print "all: $(TARGET)", "\n\n"
  mfile.print("bin/#{target}: #{target} bin\n\t$(COPY) ")
  mfile.print("#{target} bin/#{target}\n")
  mfile.print "install: bin/#{target}", "\n\n"
  ["bin"].each {|dir| mfile.print "#{dir}:\n\t$(MAKEDIRS) $@\n"}
  mfile.print CLEANINGS
ensure
  mfile.close if mfile
end

create "live_segmenter"
