# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.36"
inherit autotools python-single-r1 vala

DESCRIPTION="Internal communication framework and user/group management for Seafile server"
HOMEPAGE="https://github.com/haiwen/ccnet-server/ http://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}-server.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3.0 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=net-libs/libsearpc-3.0.8-r3
	>=dev-lang/vala-0.36
	>=dev-libs/glib-2.26.0"
RDEPEND="${DEPEND}
	"

S=${WORKDIR}/${P}-server

src_prepare() {
	default
	sed -i -e "s/(DESTDIR)//" libccnet.pc.in || die
	sed -i -e "s/\bvalac\b/valac-$(vala_best_api_version)/" lib/Makefile.am || die
	sed -i -r -e 's/AM_INIT_AUTOMAKE\(\[(.*)\]\)/AM_INIT_AUTOMAKE\([\1 subdir-objects]\)/' configure.ac || die
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files, as recommended by ltprune.eclass
	find "${ED}" -name '*.la' -delete || die
}
