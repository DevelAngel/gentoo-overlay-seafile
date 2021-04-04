# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 python3_9 )

inherit distutils-r1
MY_PV_PRE=$(ver_cut 5)
if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/marcoh00/radicale-auth-ldap.git"
	EGIT_REPO_BRANCH="master"
	inherit git-r3
elif [ -n "${MY_PV_PRE}" ]; then
	EGIT_REPO_URI="https://github.com/marcoh00/radicale-auth-ldap.git"
	EGIT_REPO_BRANCH="master"
	EGIT_COMMIT_DATE="${MY_PV_PRE}"
	inherit git-r3
else
	SRC_URI="https://github.com/marcoh00/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
fi

DESCRIPTION="LDAP Authentication Plugin for Radicale"
HOMEPAGE="https://github.com/marcoh00/radicale-auth-ldap"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~arm64 ~arm"
IUSE=""
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

RDEPEND="${DEPEND}
	>=dev-python/ldap3-2.3
	"

PDEPEND="
	>=www-apps/radicale-2.0
	"

