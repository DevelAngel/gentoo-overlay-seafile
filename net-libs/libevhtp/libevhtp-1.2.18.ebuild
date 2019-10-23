# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils cmake-utils

DESCRIPTION="Extremely-fast and secure embedded HTTP servers with ease"
HOMEPAGE="https://github.com/criticalstack/libevhtp/ https://criticalstack.com/"
SRC_URI="https://github.com/criticalstack/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
IUSE=""

# libevent debug use flag needed for malloc-replacement feature
DEPEND=">=dev-libs/libevent-2[debug]
	dev-libs/openssl
	dev-libs/oniguruma"
RDEPEND="${DEPEND}"
