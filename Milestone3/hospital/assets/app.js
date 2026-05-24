document.addEventListener('DOMContentLoaded', function () {
    const menuToggle = document.querySelector('.menu-toggle');
    const mainNav = document.querySelector('.main-nav');

    if (menuToggle && mainNav) {
        menuToggle.addEventListener('click', function () {
            mainNav.classList.toggle('open');
        });
    }

    const querySelect = document.getElementById('query_no');
    const filters = document.querySelectorAll('.query-filter');
    const help = document.getElementById('query-help');

    function toggleQueryFilters() {
        if (!querySelect) return;
        const selected = querySelect.value;

        filters.forEach(function (filter) {
            filter.classList.remove('show');
        });

        document.querySelectorAll('[data-query-filter="' + selected + '"]').forEach(function (filter) {
            filter.classList.add('show');
        });

        if (help) {
            if (selected === '9') {
                help.textContent = 'Query 9 needs a Doctor No to show performance history.';
                help.style.display = 'block';
            } 
            else if (selected === '10') {
                help.textContent = 'Query 10 needs a Patient No to show full medical details.';
                help.style.display = 'block';
            } 
            else if (selected === '11') {
                help.textContent = 'Query 11 needs a Complaint Code and date range.';
                help.style.display = 'block';
            } 
            else {
                help.textContent = '';
                help.style.display = 'none';
            }
        }
    }

    if (querySelect) {
        querySelect.addEventListener('change', toggleQueryFilters);
        toggleQueryFilters();
    }
});
