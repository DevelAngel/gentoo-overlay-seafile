# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit autotools python-single-r1 vala

DESCRIPTION="Seafile server core"
HOMEPAGE="https://github.com/haiwen/seafile-server/ http://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}-server.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+largefile fuse console mysql postgres"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# No forced dependency on
#  mysql? ( virtual/mysql )
#  postgres? ( dev-db/postgresql )
# which may live on another server.
DEPEND="${PYTHON_DEPS}
	=net-misc/ccnet-server-${PV}[${PYTHON_USEDEP}]
	>=net-libs/libevhtp-1.2.12
	net-libs/libsearpc[${PYTHON_USEDEP}]
	dev-libs/glib:2
	dev-libs/libevent:0
	dev-libs/jansson
	sys-libs/zlib:0
	dev-libs/openssl:0
	dev-db/sqlite:3
	"
# TODO: Is net-misc/seafile really necessary? (see src_install for details)
RDEPEND="${DEPEND}
	>=net-misc/seafile-7.0.2
	$(vala_depend)"

PATCHES=(
	"${FILESDIR}"/seafile-server-7.0.5-evhtp-1.2.11-request-keepalive.patch
	"${FILESDIR}"/seafile-server-7.0.5-evhtp-1.2.12-evhtp_set_hook.patch
	)

S=${WORKDIR}/${P}-server

src_prepare() {
	default
	sed -i -e 's/\bvalac\b/${VALAC}/' lib/Makefile.am || die
	eautoreconf
	vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable largefile)
		$(use_enable fuse)
		--enable-python
		$(use_enable console)
		$(use_with mysql)
		$(use_with postgres postgresql)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# The seafile-server still has some seafile library components
	# and wants to install them
	# Remove them to prevent file collisions with net-misc/seafile
	find "${ED}" -name 'libseafile.pc' -delete || die
	find "${ED}" -path '*/include/seafile/seafile*.h' -delete || die
	find "${ED}" -path '*/python*/site-packages/seafile/*' -delete || die
	# Remove unnecessary .la files, as recommended by ltprune.eclass
	find "${ED}" -name '*.la' -delete || die
	python_fix_shebang "${ED}"/usr/bin
}
