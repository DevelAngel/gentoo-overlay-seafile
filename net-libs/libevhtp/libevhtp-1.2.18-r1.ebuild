# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake

inherit eutils cmake-utils

DESCRIPTION="Extremely-fast and secure embedded HTTP servers with ease"
HOMEPAGE="https://github.com/criticalstack/libevhtp/ https://criticalstack.com/"
SRC_URI="https://github.com/criticalstack/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
IUSE="debug jemalloc +regex +ssl tcmalloc +threads"

DEPEND="
	>=dev-libs/libevent-2[debug?]
	jemalloc? ( dev-libs/jemalloc:0= )
	regex? ( dev-libs/oniguruma )
	ssl? ( dev-libs/openssl )
	tcmalloc? ( dev-util/google-perftools:0= )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="?? ( tcmalloc jemalloc )"

src_configure() {
	local mycmakeargs=(
		-DEVHTP_DISABLE_SSL="$(usex !ssl)"
		-DEVHTP_DISABLE_EVTHR="$(usex !threads)"
		-DEVHTP_DISABLE_REGEX="$(usex !regex)"
		-DEVHTP_DEBUG="$(usex debug)"
		-DEVHTP_DISABLE_MEMFUNCTIONS="$(usex !debug)"
	)

	# allocator library
	if use jemalloc ; then
		mycmakeargs+=( -DEVHTP_ALLOCATOR="jemalloc" )
	fi
	if use tcmalloc ; then
		mycmakeargs+=( -DEVHTP_ALLOCATOR="tcmalloc" )
	fi

	cmake-utils_src_configure
}
