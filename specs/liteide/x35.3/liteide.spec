%global version x35.3
%global arch %(test $(rpm -E%?_arch) = x86_64 && echo "x64" || echo "ia32")
%global srcdir %{_builddir}/liteide-%{version}
%global outputDir %{_builddir}/liteide-%{version}-out

Name:    liteide
Version: %{version}
Release: 1%{dist}
Summary: LiteIDE is a simple, open source, cross-platform Go IDE

Group:   Development/Tools
License: LGPL
URL:     https://github.com/visualfc/liteide

Patch0: desktop_entry.patch

BuildRequires: git
BuildRequires: qt-devel
BuildRequires: make
BuildRequires: golang

Requires: golang

%description
IDE for editing and building projects written in the Go programming language

%prep
# Clone the sources
if ! [ -d %{srcdir}/.git ]; then
  git clone %{url}.git %{srcdir}
fi
pushd %{srcdir}
# Reset the git status
  git reset --hard
  git fetch --all
  git checkout %{version}
  # Apply patches
  patch -p1 -i %{P:0}
popd

%build
export CFLAGS="%{optflags}"
export CXXFLAGS="%{optflags}"

pushd %{srcdir}/build
  export QTDIR="/usr/share/qt4"
  ./update_pkg.sh
  ./build_linux_fedora27_x64.sh
popd

%install
# Variables
buildDir="%{srcdir}/build/liteide"
outBinDir="%{buildroot}%{_bindir}"
outLibDir="%{buildroot}/lib/liteide"
outShareDir="%{buildroot}%{_datarootdir}/liteide"
outShareDocsDir="${outShareDir}/docs"
# Lib files
install -d "${outLibDir}"
for file in `ls -A ${buildDir}/lib/liteide/`; do
  cp -prf "${buildDir}/lib/liteide/$file" "${outLibDir}/"
done
# Share files
install -d "${outShareDir}"
for file in `ls -A ${buildDir}/share/liteide/`; do
  cp -prf "${buildDir}/share/liteide/$file" "${outShareDir}/"
done
# Executable binaries
install -d ${outBinDir}
for file in `ls -A ${buildDir}/bin/`; do
  install -m755 "${buildDir}/bin/${file}" "${outBinDir}/"
done
# License and contributors
install -d "${outShareDocsDir}"
install -m644 "${buildDir}/CONTRIBUTORS" "${outShareDocsDir}/CONTRIBUTORS"
install -m644 "${buildDir}/LICENSE.LGPL" "${outShareDocsDir}/LICENSE.LGPL"
install -m644 "${buildDir}/LGPL_EXCEPTION.TXT" "${outShareDocsDir}/LGPL_EXCEPTION.TXT"
install -m644 "${buildDir}/README.md" "${outShareDocsDir}/README.md"
# Desktop link
install -d "%{buildroot}%{_datarootdir}/applications"
install -m644 "${buildDir}/liteide.desktop" "%{buildroot}%{_datarootdir}/applications/liteide.desktop"

%files
%defattr(-,root,root,-)
%doc %{_datarootdir}/liteide/docs/README.md
%license %{_datarootdir}/liteide/docs/LICENSE.LGPL
%{_bindir}/gocode
%{_bindir}/gomodifytags
%{_bindir}/gotools
%{_bindir}/liteide
/lib/liteide
%{_datarootdir}/liteide
%{_datarootdir}/applications/liteide.desktop

%changelog
* Sun Dec 23 2018 Giacomo Furlan <elegos@fastwebnet.it> - x35.3
- Release x35.3
* Tue Nov 20 2018 Giacomo Furlan <elegos@fastwebnet.it> - x35.2
- Release x35.2
* Mon Oct 29 2018 Giacomo Furlan <elegos@fastwebnet.it> - x35.1-3
- Fixed desktop icon
* Thu Oct 25 2018 Giacomo Furlan <elegos@fastwebnet.it> - x35.1
- Release x35.1
* Sat Oct 06 2018 Giacomo Furlan <elegos@fastwebnet.it> - x34.3
- Release x34.3
* Mon Oct 01 2018 Giacomo Furlan <elegos@fastwebnet.it> - x34.2
- Release x34.2
* Sat Aug 25 2018 Giacomo Furlan <elegos@fastwebnet.it> - x34.1
- Release x34.1
- https://github.com/visualfc/liteide/releases/tag/x34
* Wed Jul 25 2018 Giacomo Furlan <elegos@fastwebnet.it> - x34
- Release x34
- https://github.com/visualfc/liteide/releases/tag/x34
* Fri Jul 06 2018 Giacomo Furlan <elegos@fastwebnet.it> - x33.4
- Release x33.4
- https://github.com/visualfc/liteide/releases/tag/x33.4
