# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-r1 webapp

DESCRIPTION="Seafile server web frontend"
HOMEPAGE="https://github.com/haiwen/seahub/ http://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}-server.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres +sqlite"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	"
RDEPEND="${DEPEND}
	~net-misc/seafile-server-${PV}[mysql?,postgres?]
	>=dev-python/django-1.11.23[${PYTHON_USEDEP}]
	<dev-python/django-2[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/django_compressor[${PYTHON_USEDEP}]
	dev-python/django-statici18n[${PYTHON_USEDEP}]
	dev-python/django-post_office-haiwen[${PYTHON_USEDEP}]
	dev-python/django-webpack-loader[${PYTHON_USEDEP}]
	dev-python/pymysql[${PYTHON_USEDEP}]
	dev-python/django-picklefield[${PYTHON_USEDEP}]
	dev-python/openpyxl[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/django-formtools[${PYTHON_USEDEP}]
	dev-python/django-simple-captcha[${PYTHON_USEDEP}]
	dev-python/djangorestframework[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/django-constance-haiwen[${PYTHON_USEDEP}]
	dev-python/social-auth-core[${PYTHON_USEDEP}]
	dev-python/python-openid[mysql?,postgres?,sqlite?,${PYTHON_USEDEP}]
	"
# missing:
#	dev-python/captcha
#	dev-python/gunicorn ???

DOCS=( README.markdown CONTRIBUTORS HACKING )

S=${WORKDIR}/${P}-server

pkg_setup() {
	webapp_pkg_setup
}

src_compile() {
	emake locale || die "localization failed"
}

src_install() {
	webapp_src_preinst

	einstalldocs

	python_foreach_impl python_domodule thirdpart/registration
	python_foreach_impl python_domodule thirdpart/shibboleth
	python_foreach_impl python_domodule thirdpart/social_django
	python_foreach_impl python_domodule thirdpart/termsandconditions
	python_foreach_impl python_domodule thirdpart/weworkapi

	python_foreach_impl python_newscript manage.py ${PN}-manage-${PV}

	python_moduleinto "${MY_HTDOCSDIR}"
	python_foreach_impl python_domodule seahub
	python_foreach_impl python_domodule fabfile

	insinto "${MY_HTDOCSDIR}"
	doins LICENSE.txt
	doins LICENSE-thirdparty.txt
	doins Makefile
	doins -r frontend
	doins -r locale
	doins -r media
	doins -r static
	#sql
	#tools

	webapp_configfile "${MY_HTDOCSDIR}"/Makefile

	webapp_src_install
}

